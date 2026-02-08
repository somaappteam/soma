import 'dart:async';
import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/widgets/soma_background.dart';
import '../../core/widgets/responsive.dart';
import 'circles_screen.dart';
import 'circle_countdown_screen.dart';
import 'live_quiz_screen.dart';
import '../../data/circles_repository.dart';
import '../../data/profile_repository.dart';
import '../../data/social_repository.dart';
import '../../data/notifications_repository.dart';
import '../../data/circle_voice_service.dart';
import '../../data/profile_store.dart';
import '../../data/agora_voice_service.dart';
import '../../data/quiz_repository.dart';
import '../profile/profile_screen.dart';

class CircleLobbyScreen extends StatefulWidget {
  final String circleId;
  const CircleLobbyScreen({super.key, required this.circleId});

  @override
  State<CircleLobbyScreen> createState() => _CircleLobbyScreenState();
}

class _CircleLobbyScreenState extends State<CircleLobbyScreen> {
  // RealSupabase Data
  Map<String, dynamic>? circleData;
  List<Map<String, dynamic>> participants = [];
  Map<String, Map<String, dynamic>> profilesCache = {};
  bool _hasNavigated = false;
  StreamSubscription<Map<String, VoicePresence>>? _voiceSub;
  StreamSubscription<Map<String, dynamic>>? _circleSub;

  String? get _myRole {
    final uid = circlesRepository.currentUserId;
    if (uid == null) return null;
    if (participants.isNotEmpty) {
      final me = participants.firstWhere(
        (p) => p['user_id'] == uid,
        orElse: () => {},
      );
      final role = me['role']?.toString();
      if (role != null && role.isNotEmpty) return role;
    }
    if (circleData == null) return null;
    return circleData!['host_id'] == uid ? 'host' : 'player';
  }

  bool get isHost => _myRole == 'host';
  bool get isSpectator => _myRole == 'spectator' || _myRole == 'pending';
  bool get isPendingJoin => _myRole == 'pending';

  int get _playerCount => participants
      .where((p) => p['role'] != 'spectator' && p['role'] != 'pending')
      .length;

  @override
  void initState() {
    super.initState();
    _loadCircle(); // test-no-nl
    _listenParticipants();
    _connectVoice();
    _listenCircleStatus();
  }

  @override
  void dispose() {
    _voiceSub?.cancel();
    _circleSub?.cancel();
    super.dispose();
  }

  Future<void> _loadCircle() async {
    final data = await circlesRepository.getCircleDetails(widget.circleId);
    if (mounted && data != null) {
      setState(() => circleData = data);
    }
  }

  void _listenParticipants() {
    circlesRepository
        .getParticipantsStream(widget.circleId)
        .listen((data) async {
      // 1. Fetch profiles for new user IDs
      final userIds = data.map((e) => e['user_id'] as String).toList();
      final newIds =
          userIds.where((id) => !profilesCache.containsKey(id)).toList();

      if (newIds.isNotEmpty) {
        final profiles = await profileRepository.getProfilesByIds(newIds);
        for (var p in profiles) {
          profilesCache[p['id']] = p;
        }
      }

      if (mounted) {
        setState(() => participants = data);
      }
      await _syncVoiceRole();
    });
  }

  void _listenCircleStatus() {
    _circleSub?.cancel();
    _circleSub = circlesRepository.getCircleStream(widget.circleId).listen((data) {
      if (!mounted || _hasNavigated) return;
      
      final oldStatus = circleData?['status']?.toString();
      final newStatus = data['status']?.toString();

      setState(() => circleData = data);

      if (newStatus == 'active') {
        final qs = data['questions'] as List?;
        if (qs != null && qs.isNotEmpty) {
          _hasNavigated = true;
          _navigateToCountdown();
        } else {
          debugPrint("CircleLobby: Status is active but questions are missing. Waiting for questions...");
        }
      }
    });
  }

  void _navigateToCountdown() {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CircleCountdownScreen(
          seconds: 3,
          circleId: widget.circleId,
          onFinished: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => LiveQuizScreen(
                  questions: List<Map<String, dynamic>>.from(circleData?['questions'] ?? []),
                  timePerQ: circleData?['time_per_q'] ?? 10,
                  role: isHost ? LiveQuizRole.host : LiveQuizRole.participant,
                  circleId: widget.circleId,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleHostExit() async {
    final l10n = AppLocalizations.of(context)!;
    final candidates = _hostCandidates();
    final canTransfer = candidates.isNotEmpty;
    final action = await _promptHostExit(canTransfer: canTransfer);
    if (action == null) return;

    if (action == _HostExitAction.transfer) {
      final newHostId = await _pickNewHost(candidates);
      if (newHostId == null) return;
      try {
        await circlesRepository.transferHost(
            circleId: widget.circleId, newHostId: newHostId);
        await circlesRepository.leaveCircle(widget.circleId);
        await circleVoiceService.disconnectIfCircle(widget.circleId);
        await agoraVoiceService.disconnectIfCircle(widget.circleId);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          _toast(context, l10n.circlesTransferHostFailed(e.toString()));
        }
      }
      return;
    }

    try {
      await circlesRepository.endCircle(widget.circleId);
      await circlesRepository.leaveCircle(widget.circleId);
      await circleVoiceService.disconnectIfCircle(widget.circleId);
      await agoraVoiceService.disconnectIfCircle(widget.circleId);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        _toast(context, l10n.circlesEndCircleFailed(e.toString()));
      }
    }
  }

  bool _isMutedFor(String userId) =>
      circleVoiceService.voiceFor(userId)?.muted ?? false;
  bool _isSpeakingFor(String userId) =>
      circleVoiceService.voiceFor(userId)?.speaking ?? false;

  void _toggleMuteFor(String userId) {
    agoraVoiceService.toggleMuted();
  }

  Future<void> _connectVoice() async {
    final l10n = AppLocalizations.of(context)!;
    final profile = profileStore.profile;
    final name = profile.displayName.isNotEmpty
        ? profile.displayName
        : (profile.username.isNotEmpty ? profile.username : l10n.genericUser);

    await circleVoiceService.connect(circleId: widget.circleId, name: name);
    await agoraVoiceService.connect(
        circleId: widget.circleId, asSpeaker: !isSpectator);
    _voiceSub?.cancel();
    _voiceSub = circleVoiceService.stream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _syncVoiceRole() async {
    await agoraVoiceService.connect(
        circleId: widget.circleId, asSpeaker: !isSpectator);
  }

  Future<void> _inviteByUsername() async {
    final l10n = AppLocalizations.of(context)!;
    final username = await _promptInviteUsername();
    if (username == null || username.isEmpty) return;

    try {
      final users = await socialRepository.searchUsers(username);
      final target = users.firstWhere(
        (u) =>
            (u['username'] as String?)?.toLowerCase() == username.toLowerCase(),
        orElse: () => {},
      );

      if (target.isEmpty) {
        _toast(context, l10n.circlesUserNotFound(username));
        return;
      }

      final targetId = target['id']?.toString();
      if (targetId == null) {
        _toast(context, l10n.circlesInvalidUser);
        return;
      }

      if (targetId == circlesRepository.currentUserId) {
        _toast(context, l10n.circlesCantInviteSelf);
        return;
      }

      final alreadyInCircle =
          participants.any((p) => p['user_id']?.toString() == targetId);
      if (alreadyInCircle) {
        _toast(context, l10n.circlesUserAlreadyInCircle(username));
        return;
      }

      final hostProfile = await profileRepository.fetchProfile();
      final hostName = hostProfile?.displayName.isNotEmpty == true
          ? hostProfile!.displayName
          : (hostProfile?.username.isNotEmpty == true
              ? hostProfile!.username
              : l10n.circlesDefaultHost);

      final circleTitle =
          circleData?['name']?.toString() ?? l10n.circlesDefaultTitle;

      final hostId = circlesRepository.currentUserId;
      if (hostId == null) {
        _toast(context, l10n.authNotSignedIn);
        return;
      }

      await notificationsRepository.sendCircleInvite(
        toUserId: targetId,
        circleId: widget.circleId,
        circleTitle: circleTitle,
        fromUserId: hostId,
        fromUserName: hostName,
      );

      _toast(context, l10n.circlesInviteSent(username));
    } catch (e) {
      _toast(context, l10n.circlesInviteFailed(e.toString()));
    }
  }

  void _openProfileSheet(String? userId) {
    if (userId == null || userId.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final height = MediaQuery.of(context).size.height * 0.92;
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SizedBox(
            height: height,
            child: ProfileScreen(userId: userId),
          ),
        );
      },
    );
  }

  Future<String?> _promptInviteUsername() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1C),
          title: Text(
            l10n.circlesInviteByUsername,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: l10n.authUsername,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel,
                  style: TextStyle(color: Colors.white.withOpacity(0.75))),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text.trim();
                Navigator.pop(
                    ctx, text.startsWith('@') ? text.substring(1) : text);
              },
              child: Text(
                l10n.send,
                style: const TextStyle(
                    color: Color(0xFF2AFADF), fontWeight: FontWeight.w900),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestJoin() async {
    final l10n = AppLocalizations.of(context)!;
    if (isPendingJoin) return;
    try {
      await circlesRepository.requestToJoin(widget.circleId);
      if (mounted) {
        _toast(context, l10n.circlesJoinRequestSent);
      }
    } catch (e) {
      if (mounted) {
        _toast(context, l10n.circlesJoinRequestFailed(e.toString()));
      }
    }
  }

  Future<void> _approveJoin(String userId, {required bool hasCapacity}) async {
    final l10n = AppLocalizations.of(context)!;
    if (!hasCapacity) {
      _toast(context, l10n.circlesFull);
      return;
    }
    try {
      await circlesRepository.approveJoinRequest(
          circleId: widget.circleId, userId: userId);
      if (mounted) {
        _toast(context, l10n.circlesSpectatorAdded);
      }
    } catch (e) {
      if (mounted) {
        _toast(context, l10n.circlesApproveFailed(e.toString()));
      }
    }
  }

  Future<void> _declineJoin(String userId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await circlesRepository.declineJoinRequest(
          circleId: widget.circleId, userId: userId);
      if (mounted) {
        _toast(context, l10n.circlesRequestDeclined);
      }
    } catch (e) {
      if (mounted) {
        _toast(context, l10n.circlesDeclineFailed(e.toString()));
      }
    }
  }

  List<_HostCandidate> _hostCandidates() {
    final l10n = AppLocalizations.of(context)!;
    final currentId = circlesRepository.currentUserId;
    return participants
        .where((p) => p['user_id'] != null && p['user_id'] != currentId)
        .map((p) {
      final uid = p['user_id'] as String;
      final profile = profilesCache[uid];
      return _HostCandidate(
        userId: uid,
        name: profile?['display_name'] ?? l10n.circlesParticipant,
      );
    }).toList();
  }

  Future<_HostExitAction?> _promptHostExit({required bool canTransfer}) async {
    return showDialog<_HostExitAction>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1C),
          title: Text(
            l10n.circlesLeavePromptTitle,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900),
          ),
          content: Text(
            canTransfer
                ? l10n.circlesLeavePromptTransfer
                : l10n.circlesLeavePromptEndOnly,
            style: TextStyle(
                color: Colors.white.withOpacity(0.78),
                fontWeight: FontWeight.w600),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel,
                  style: TextStyle(color: Colors.white.withOpacity(0.75))),
            ),
            if (canTransfer)
              TextButton(
                onPressed: () => Navigator.pop(ctx, _HostExitAction.transfer),
                child: Text(l10n.circlesTransferHost,
                    style: const TextStyle(
                        color: Color(0xFF2AFADF), fontWeight: FontWeight.w900)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, _HostExitAction.end),
              child: Text(l10n.circlesEndCircle,
                  style: const TextStyle(
                      color: Color(0xFFFF4ECD), fontWeight: FontWeight.w900)),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _pickNewHost(List<_HostCandidate> candidates) async {
    if (candidates.isEmpty) return null;
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        final maxHeight = MediaQuery.of(ctx).size.height * 0.65;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Glass(
              radius: BorderRadius.circular(24),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: SizedBox(
                height: maxHeight,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        Text(
                          l10n.circlesTransferHostTitle,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: Icon(Icons.close_rounded,
                              color: Colors.white.withOpacity(0.85)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...candidates.map((c) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.pop(ctx, c.userId),
                        child: Container(
                          height: 52,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black.withOpacity(0.12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.14)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person_rounded,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  c.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded,
                                  color: Colors.white.withOpacity(0.6)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Derived getters
  String get circleCode {
    if (circleData == null) return "...";
    // We can show the first few chars of UUID or a 'name'
    // Format: "NAME • 3/5"
    final current = _playerCount;
    final max = circleData!['max_players'] ?? 5;
    return "${"Code: ${widget.circleId.substring(0, 4).toUpperCase()}"} • $current/$max";
  }

  @override
  Widget build(BuildContext context) {
    if (circleData == null) {
      return const Scaffold(
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF2AFADF))),
      );
    }
    final l10n = AppLocalizations.of(context)!;

    // Construct display players
    final maxPlayers = circleData!['max_players'] ?? 5;
    final codeLine = l10n.circlesCodeLine(
      widget.circleId.substring(0, 4).toUpperCase(),
      _playerCount,
      maxPlayers,
    );
    final modeRaw = circleData?['mode']?.toString() ?? '';
    final modeLabel = modeRaw.toLowerCase() == 'vocabulary'
        ? l10n.soloModeVocabulary
        : modeRaw.toLowerCase() == 'sentences'
            ? l10n.soloModeSentences
            : modeRaw;
    final levelRaw = circleData?['level']?.toString() ?? '';
    final levelLabel = _localizedLevelLabel(l10n, levelRaw);
    final displayPlayers = <PlayerSlot>[];
    final playerParticipants = participants
        .where((p) => p['role'] != 'spectator' && p['role'] != 'pending')
        .toList();
    final spectatorParticipants =
        participants.where((p) => p['role'] == 'spectator').toList();
    final pendingParticipants =
        participants.where((p) => p['role'] == 'pending').toList();

    for (int i = 0; i < maxPlayers; i++) {
      if (i < playerParticipants.length) {
        final p = playerParticipants[i];
        final uid = p['user_id'];
        final profile = profilesCache[uid];
        final isPReady = p['is_ready'] ?? false;
        final role = p['role'];
        final userId = uid?.toString();
        final isSelf =
            userId != null && userId == circlesRepository.currentUserId;
        final isMuted = userId != null ? _isMutedFor(userId) : false;
        final isSpeaking = userId != null ? _isSpeakingFor(userId) : false;

        displayPlayers.add(PlayerSlot(
          name: profile?['display_name'] ?? l10n.loading,
          isHost: role == 'host',
          isReady: isPReady,
          score: 0,
          userId: userId,
          isMuted: isMuted,
          isSpeaking: isSpeaking,
          isSelf: isSelf,
        ));
      } else {
        displayPlayers.add(PlayerSlot(
            name: l10n.circlesEmptySlot,
            isHost: false,
            isReady: false,
            score: 0,
            isEmpty: true));
      }
    }

    final allReady =
        displayPlayers.where((p) => !p.isEmpty).every((p) => p.isReady);

    return WillPopScope(
      onWillPop: () async {
        if (!isHost) return true;
        await _handleHostExit();
        return false;
      },
      child: Scaffold(
        body: SomaBackground(
          child: SafeArea(
            child: ResponsiveFrame(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                child: Column(
                  children: [
                    _TopBar(
                      title: circleData?['name'] ?? l10n.circlesLobbyTitle,
                      subtitle: codeLine,
                      onBack: () {
                        if (!isHost) {
                          Navigator.pop(context);
                          return;
                        }
                        _handleHostExit();
                      },
                      onShare: () {
                        _toast(context, l10n.circlesShareId(widget.circleId));
                      },
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // Settings summary card
                          Glass(
                            radius: BorderRadius.circular(26),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionTitle(l10n.circlesMatchSettings),
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _PillInfo(
                                        icon: Icons.translate_rounded,
                                        title:
                                            "${circleData!['from_lang']} → ${circleData!['to_lang']}",
                                        subtitle: l10n.circlesLanguages,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _PillInfo(
                                        icon:
                                            Icons.local_fire_department_rounded,
                                        title: modeLabel,
                                        subtitle: l10n.circlesModeTitle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _PillInfo(
                                        icon: Icons.stacked_bar_chart_rounded,
                                        title: l10n
                                            .circlesLevelWithValue(levelLabel),
                                        subtitle: l10n.circlesDifficulty,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _PillInfo(
                                        icon: Icons.help_outline_rounded,
                                        title: l10n.questionsShort(
                                            circleData!['questions_count'] ??
                                                0),
                                        subtitle: l10n.circlesQuestions,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _PillInfo(
                                        icon: Icons.timer_rounded,
                                        title: l10n.secondsShort(
                                            circleData!['time_per_q'] ?? 0),
                                        subtitle: l10n.circlesPerQuestionShort,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // Simplified quick actions
                                Row(
                                  children: [
                                    if (isHost) ...[
                                      Expanded(
                                        child: _QuickAction(
                                          icon: Icons.person_add_alt_1_rounded,
                                          label: l10n.circlesInvite,
                                          onTap: _inviteByUsername,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                    Expanded(
                                      child: _QuickAction(
                                        icon: Icons.copy_rounded,
                                        label: l10n.circlesCopyId,
                                        onTap: () => _toast(
                                            context, l10n.circlesCopiedId),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                if (isHost)
                                  _HostControlsRow(
                                    roomLocked:
                                        false, // TODO: implement lock in schema
                                    onToggleLock: (v) {},
                                    onEdit: () {},
                                  )
                                else if (isSpectator)
                                  _SpectatorTip()
                                else
                                  _PlayerTip(),
                              ],
                            ),
                          ),

                          if (isSpectator &&
                              circleData?['status'] == 'active') ...[
                            const SizedBox(height: 12),
                            _StatusCallout(
                              title: l10n.circlesMatchInProgress,
                              body: l10n.circlesSpectatorQueuedBody,
                            ),
                          ],

                          const SizedBox(height: 14),

                          // Players card
                          Glass(
                            radius: BorderRadius.circular(26),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _SectionTitle(l10n.circlesPlayers),
                                    const Spacer(),
                                    Text(
                                      "${playerParticipants.length}/$maxPlayers",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.70),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...displayPlayers.map((p) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: _PlayerRow(
                                        player: p,
                                        onKick: null, // Host kick logic later
                                        onToggleReady: isSpectator
                                            ? null
                                            : () async {
                                                if (p.isEmpty) return;
                                                // Find 'my' participant entry and toggle it
                                                // This UI is a bit tricky because we're mapping
                                                // displayPlayers (UI model) back to logic
                                                // Better: just have a single "Ready" button at bottom
                                              },
                                        onToggleMute: p.isSelf &&
                                                p.userId != null
                                            ? () => _toggleMuteFor(p.userId!)
                                            : null,
                                        onAvatarTap: p.userId != null
                                            ? () => _openProfileSheet(p.userId)
                                            : null,
                                      ),
                                    )),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.circlesHostStartWhenReady,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.62),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          if (spectatorParticipants.isNotEmpty) ...[
                            Glass(
                              radius: BorderRadius.circular(26),
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _SectionTitle(l10n.circlesSpectators),
                                      const Spacer(),
                                      Text(
                                        "${spectatorParticipants.length}",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.70),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: spectatorParticipants.map((p) {
                                      final uid = p['user_id'];
                                      final profile = profilesCache[uid];
                                      final name = profile?['display_name'] ??
                                          profile?['username'] ??
                                          l10n.circlesSpectator;
                                      return _SpectatorChip(
                                        name: name,
                                        onTap: uid != null
                                            ? () => _openProfileSheet(
                                                uid.toString())
                                            : null,
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    l10n.circlesSpectatorCanWatch,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.62),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          if (isHost && pendingParticipants.isNotEmpty) ...[
                            Glass(
                              radius: BorderRadius.circular(26),
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _SectionTitle(l10n.circlesJoinRequests),
                                      const Spacer(),
                                      Text(
                                        "${pendingParticipants.length}",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.70),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...pendingParticipants.map((p) {
                                    final uid = p['user_id']?.toString();
                                    final profile = profilesCache[uid];
                                    final name = profile?['display_name'] ??
                                        profile?['username'] ??
                                        l10n.circlesSpectator;
                                    final isActive =
                                        circleData?['status'] == 'active';
                                    final hasCapacity =
                                        playerParticipants.length < maxPlayers;
                                    final canAccept = !isActive && hasCapacity;
                                    if (uid == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return _JoinRequestRow(
                                      name: name,
                                      canAccept: canAccept,
                                      onAccept: () => _approveJoin(uid,
                                          hasCapacity: hasCapacity),
                                      onDecline: () => _declineJoin(uid),
                                    );
                                  }),
                                  const SizedBox(height: 6),
                                  Text(
                                    l10n.circlesAcceptSpectatorsHint,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.62),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Bottom CTA
                          if (isHost) ...[
                            NeonButton(
                              label: allReady
                                  ? l10n.circlesStartGame
                                  : l10n.circlesWaitingForPlayers,
                              onTap: allReady
                                  ? () async {
                                      if (circleData == null) return;
                                      
                                      // 1. If questions are missing, fetch them now
                                      final currentQs = circleData?['questions'] as List?;
                                      if (currentQs == null || currentQs.isEmpty) {
                                        debugPrint("CircleLobby: Host starting but questions missing. Fetching...");
                                        try {
                                          final learnLang = circleData?['to_lang']?.toString() ?? 'es';
                                          final speakLang = circleData?['from_lang']?.toString() ?? 'en';
                                          final mode = circleData?['mode']?.toString() ?? 'Vocabulary';
                                          final count = circleData?['questions_count'] ?? 10;
                                          final courseId = "$speakLang-$learnLang";

                                          List<Map<String, dynamic>> newQs = [];
                                          if (mode == "Vocabulary") {
                                            newQs = await quizRepository.getVocabQuestionsFromSupabase(courseId, count);
                                          } else {
                                            newQs = await quizRepository.getSentenceQuestionsFromSupabase(courseId, count);
                                          }

                                          if (newQs.isNotEmpty) {
                                            await circlesRepository.updateCircleQuestions(widget.circleId, newQs);
                                            debugPrint("CircleLobby: Uploaded ${newQs.length} questions.");
                                          }
                                        } catch (e) {
                                          debugPrint("CircleLobby: Error pre-fetching questions: $e");
                                        }
                                      }

                                      // 2. Set status to active (this triggers navigation for everyone)
                                      await circlesRepository.updateCircleStatus(widget.circleId, 'active');
                                    }
                                  : () {},
                            ),
                            const SizedBox(height: 10),
                            _SecondaryButton(
                              label: l10n.circlesLeaveCircle,
                              onTap: () {
                                _handleHostExit();
                              },
                            ),
                          ] else if (isSpectator) ...[
                            NeonButton(
                              label: isPendingJoin
                                  ? l10n.circlesRequestSent
                                  : l10n.circlesRequestToJoin,
                              onTap: isPendingJoin ? null : _requestJoin,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _SecondaryButton(
                                    label: l10n.leave,
                                    onTap: () async {
                                      await circlesRepository
                                          .leaveCircle(widget.circleId);
                                      await circleVoiceService
                                          .disconnectIfCircle(widget.circleId);
                                      await agoraVoiceService
                                          .disconnectIfCircle(widget.circleId);
                                      if (mounted) Navigator.pop(context);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: NeonButton(
                                    label: l10n.circlesWatchLive,
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LiveQuizScreen(
                                            questions:
                                                List<Map<String, dynamic>>.from(
                                                    circleData?['questions'] ??
                                                        []),
                                            timePerQ:
                                                circleData?['time_per_q'] ?? 10,
                                            role: LiveQuizRole.spectator,
                                            circleId: widget.circleId,
                                            joinRequested: isPendingJoin,
                                          ),
                                        ),
                                      );
                                      if (mounted) {
                                        _loadCircle();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: _SecondaryButton(
                                    label: l10n.leave,
                                    onTap: () async {
                                      await circlesRepository
                                          .leaveCircle(widget.circleId);
                                      await circleVoiceService
                                          .disconnectIfCircle(widget.circleId);
                                      await agoraVoiceService
                                          .disconnectIfCircle(widget.circleId);
                                      if (mounted) Navigator.pop(context);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: NeonButton(
                                    label: l10n.ready,
                                    onTap: () async {
                                      // Identify self
                                      final me = participants.firstWhere(
                                        (p) =>
                                            p['user_id'] ==
                                            circlesRepository.currentUserId,
                                        orElse: () => {},
                                      );
                                      if (me.isNotEmpty) {
                                        final currentReady =
                                            me['is_ready'] ?? false;
                                        await circlesRepository.toggleReady(
                                            widget.circleId, !currentReady);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _HostExitAction { transfer, end }

String _localizedLevelLabel(AppLocalizations l10n, String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return value;
  final upper = trimmed.toUpperCase();
  if (upper == 'A') return l10n.levelBeginner;
  if (upper == 'B') return l10n.levelIntermediate;
  if (upper == 'C') return l10n.levelAdvanced;
  return value;
}

class _HostCandidate {
  final String userId;
  final String name;

  const _HostCandidate({required this.userId, required this.name});
}

class PlayerSlot {
  final String name;
  bool isReady;
  final bool isHost;
  final int score;
  final bool isEmpty;
  final String? userId;
  final bool isMuted;
  final bool isSpeaking;
  final bool isSelf;

  PlayerSlot({
    required this.name,
    required this.isHost,
    required this.isReady,
    required this.score,
    this.isEmpty = false,
    this.userId,
    this.isMuted = false,
    this.isSpeaking = false,
    this.isSelf = false,
  });
}

/// ---------------- UI Components ----------------

class _TopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onShare;

  const _TopBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconGlassButton(icon: Icons.arrow_back_rounded, onTap: onBack),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.70),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _IconGlassButton(icon: Icons.ios_share_rounded, onTap: onShare),
      ],
    );
  }
}

class _IconGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconGlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(16),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Center(
            child: Icon(icon, color: Colors.white.withOpacity(0.92), size: 22),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.92),
        fontWeight: FontWeight.w900,
        fontSize: 14,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _PillInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PillInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withOpacity(0.14),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.black.withOpacity(0.12),
          border: Border.all(color: Colors.white.withOpacity(0.14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _HostControlsRow extends StatelessWidget {
  final bool roomLocked;
  final ValueChanged<bool> onToggleLock;
  final VoidCallback onEdit;

  const _HostControlsRow({
    required this.roomLocked,
    required this.onToggleLock,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withOpacity(0.14),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          const Icon(Icons.admin_panel_settings_rounded,
              color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.circlesHostControls,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          TextButton(
            onPressed: onEdit,
            child: Text(
              l10n.edit,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 6),
          Row(
            children: [
              Icon(Icons.lock_rounded,
                  color: Colors.white.withOpacity(0.75), size: 18),
              Switch(
                value: roomLocked,
                onChanged: onToggleLock,
                activeThumbColor: const Color(0xFF2AFADF),
                activeTrackColor: const Color(0xFF7C7CFF).withOpacity(0.45),
                inactiveThumbColor: Colors.white.withOpacity(0.70),
                inactiveTrackColor: Colors.white.withOpacity(0.18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerTip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withOpacity(0.12),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: Colors.white.withOpacity(0.85), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Tap Ready when you’re set. Host will start the match.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.80),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpectatorTip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withOpacity(0.12),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Icon(Icons.visibility_rounded,
              color: Colors.white.withOpacity(0.85), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "You're spectating. Watch live once the host starts.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.80),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCallout extends StatelessWidget {
  final String title;
  final String body;

  const _StatusCallout({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.10),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
            ),
            child: Icon(Icons.hourglass_top_rounded,
                color: Colors.white.withOpacity(0.9), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.68),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final PlayerSlot player;
  final VoidCallback? onKick;
  final VoidCallback? onToggleReady;
  final VoidCallback? onToggleMute;
  final VoidCallback? onAvatarTap;

  const _PlayerRow({
    required this.player,
    required this.onKick,
    required this.onToggleReady,
    required this.onToggleMute,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final readyColor = player.isReady
        ? const Color(0xFF2AFADF)
        : Colors.white.withOpacity(0.35);

    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withOpacity(player.isEmpty ? 0.08 : 0.14),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: player.isEmpty ? null : onAvatarTap,
            child: _AvatarDot(
              glow: player.isHost,
              empty: player.isEmpty,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        player.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white
                              .withOpacity(player.isEmpty ? 0.55 : 1),
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (player.isHost && !player.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Colors.white.withOpacity(0.10),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.18)),
                        ),
                        child: const Text(
                          "HOST",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: readyColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: readyColor.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      player.isEmpty
                          ? "Waiting for player"
                          : (player.isReady ? "Ready" : "Not ready"),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.70),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!player.isEmpty) ...[
            if (onToggleMute != null)
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: onToggleMute,
                child: _MicBadge(
                    muted: player.isMuted, speaking: player.isSpeaking),
              )
            else
              _MicBadge(muted: player.isMuted, speaking: player.isSpeaking),
            const SizedBox(width: 8),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onToggleReady,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.black.withOpacity(0.12),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Icon(
                  player.isReady
                      ? Icons.check_rounded
                      : Icons.hourglass_bottom_rounded,
                  color: Colors.white.withOpacity(0.88),
                ),
              ),
            ),
          ],
          if (onKick != null) ...[
            const SizedBox(width: 10),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onKick,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.black.withOpacity(0.12),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Icon(Icons.close_rounded,
                    color: Colors.white.withOpacity(0.85)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MicBadge extends StatelessWidget {
  final bool muted;
  final bool speaking;

  const _MicBadge({required this.muted, required this.speaking});

  @override
  Widget build(BuildContext context) {
    final color =
        muted ? Colors.white.withOpacity(0.55) : Colors.white.withOpacity(0.92);
    final bg =
        muted ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.12);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: bg,
            border: Border.all(color: Colors.white.withOpacity(0.14)),
            boxShadow: speaking
                ? [
                    BoxShadow(
                      color: const Color(0xFF2AFADF).withOpacity(0.45),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            muted ? Icons.mic_off_rounded : Icons.mic_rounded,
            color: color,
            size: 20,
          ),
        ),
        if (speaking)
          Positioned(
            bottom: 6,
            right: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2AFADF),
              ),
            ),
          ),
      ],
    );
  }
}

class _JoinRequestRow extends StatelessWidget {
  final String name;
  final bool canAccept;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _JoinRequestRow({
    required this.name,
    required this.canAccept,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.black.withOpacity(0.12),
          border: Border.all(color: Colors.white.withOpacity(0.14)),
        ),
        child: Row(
          children: [
            const Icon(Icons.person_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5,
                ),
              ),
            ),
            _MiniAction(
              icon: Icons.close_rounded,
              onTap: onDecline,
            ),
            const SizedBox(width: 8),
            _MiniAction(
              icon: Icons.check_rounded,
              onTap: canAccept ? onAccept : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _MiniAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Icon(icon, color: Colors.white.withOpacity(0.92), size: 20),
        ),
      ),
    );
  }
}

class _AvatarDot extends StatelessWidget {
  final bool glow;
  final bool empty;

  const _AvatarDot({required this.glow, required this.empty});

  @override
  Widget build(BuildContext context) {
    final color =
        empty ? Colors.white.withOpacity(0.18) : Colors.white.withOpacity(0.85);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: glow
            ? [
                BoxShadow(
                  color: const Color(0xFF7C7CFF).withOpacity(0.45),
                  blurRadius: 18,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          empty ? Icons.person_outline_rounded : Icons.person_rounded,
          color: Colors.black.withOpacity(0.70),
        ),
      ),
    );
  }
}

class _SpectatorChip extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;

  const _SpectatorChip({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.black.withOpacity(0.12),
          border: Border.all(color: Colors.white.withOpacity(0.14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.black.withOpacity(0.16),
          border: Border.all(color: Colors.white.withOpacity(0.16)),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

/// small helper toast
void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
    ),
  );
}


