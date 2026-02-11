import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';

import '../../core/widgets/responsive.dart';
import 'circle_countdown_screen.dart';
import 'live_quiz_screen.dart';
import '../../core/theme/tokens.dart';
import '../../data/circles_repository.dart';
import '../../data/profile_repository.dart';
import '../../data/social_repository.dart';
import '../../data/notifications_repository.dart';
import '../../data/circle_voice_service.dart';
import '../../data/profile_store.dart';
import '../../data/agora_voice_service.dart';
import '../../data/quiz_repository.dart';
import '../../data/languages.dart';
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
  bool _editingLobbySettings = false;
  bool _savingLobbySettings = false;
  String _editSpeakLang = '';
  String _editLearnLang = '';
  String _editMode = '';
  String _editLevel = '';
  int _editQuestions = 0;
  int _editTimePerQ = 0;

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
        return;
      }

      if (newStatus == 'ended' || newStatus == 'terminated' || newStatus == 'closed') {
        _hasNavigated = true;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('This circle has been terminated by the host.')),
          );
        Navigator.pop(context);
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
    final l10n = AppLocalizations.of(context);
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

  Future<void> _openLobbyActionsSheet() async {
    final l10n = AppLocalizations.of(context);
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Glass(
          radius: const BorderRadius.vertical(top: Radius.circular(24)),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    l10n.circlesLobbyTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  _IconGlassButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (!isSpectator) ...[
                _LobbyActionTile(
                  icon: Icons.person_add_alt_1_rounded,
                  title: l10n.circlesInvite,
                  subtitle: l10n.circlesInviteByUsername,
                  onTap: () {
                    Navigator.pop(context);
                    _inviteByUsername();
                  },
                ),
                const SizedBox(height: 10),
              ],
              _LobbyActionTile(
                icon: Icons.copy_rounded,
                title: l10n.circlesCopyId,
                subtitle: l10n.circlesShareId(widget.circleId),
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: widget.circleId));
                  if (!mounted) return;
                  Navigator.pop(context);
                  _toast(context, l10n.circlesCopiedId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _toggleRoomLock(bool value) async {
    final l10n = AppLocalizations.of(context);
    try {
      await circlesRepository.updateCircleLock(widget.circleId, value);
      if (!mounted) return;
      setState(() {
        circleData = {
          ...?circleData,
          'is_locked': value,
        };
      });
      _toast(
        context,
        value ? l10n.circlesRoomLocked : l10n.circlesRoomUnlocked,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.circlesUpdateFailed(e.toString()))),
      );
    }
  }

  void _beginLobbySettingsEdit() {
    if (circleData == null) return;
    setState(() {
      _editingLobbySettings = true;
      _editSpeakLang = circleData?['from_lang']?.toString() ?? 'en';
      _editLearnLang = circleData?['to_lang']?.toString() ?? 'es';
      _editMode = circleData?['mode']?.toString() ?? 'Vocabulary';
      _editLevel = circleData?['level']?.toString() ?? 'A';
      _editQuestions = circleData?['questions_count'] ?? 10;
      _editTimePerQ = circleData?['time_per_q'] ?? 10;
    });
  }

  void _cancelLobbySettingsEdit() {
    setState(() {
      _editingLobbySettings = false;
      _savingLobbySettings = false;
    });
  }

  Future<void> _saveLobbySettingsEdit() async {
    final l10n = AppLocalizations.of(context);
    if (_savingLobbySettings) return;
    setState(() => _savingLobbySettings = true);
    try {
      await circlesRepository.updateCircleMatchSettings(
        circleId: widget.circleId,
        fromLang: _editSpeakLang,
        toLang: _editLearnLang,
        mode: _editMode,
        level: _editLevel,
        questionsCount: _editQuestions,
        timePerQ: _editTimePerQ,
      );

      final courseId = "${_editSpeakLang}-${_editLearnLang}";
      List<Map<String, dynamic>> newQuestions = [];
      if (_editMode == "Vocabulary") {
        newQuestions = await quizRepository.getVocabQuestionsFromSupabase(
          courseId,
          _editQuestions,
        );
      } else {
        newQuestions = await quizRepository.getSentenceQuestionsFromSupabase(
          courseId,
          _editQuestions,
        );
      }

      if (newQuestions.isEmpty) {
        throw Exception("No questions found for $courseId.");
      }

      if (newQuestions.isNotEmpty) {
        await circlesRepository.updateCircleQuestions(
          widget.circleId,
          newQuestions,
        );
      }

      if (!mounted) return;
      setState(() {
        circleData = {
          ...?circleData,
          'from_lang': _editSpeakLang,
          'to_lang': _editLearnLang,
          'mode': _editMode,
          'level': _editLevel,
          'questions_count': _editQuestions,
          'time_per_q': _editTimePerQ,
          'questions': newQuestions,
        };
        _editingLobbySettings = false;
      });
      _toast(context, l10n.circlesSettingsSaved);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.circlesUpdateFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _savingLobbySettings = false);
      }
    }
  }

  Future<void> _toggleLobbySettingsEdit() async {
    if (_editingLobbySettings) {
      await _saveLobbySettingsEdit();
    } else {
      _beginLobbySettingsEdit();
    }
  }

  String _languageName(String code) {
    return kLanguages.firstWhere(
      (l) => l.code == code,
      orElse: () => kLanguages.first,
    ).name;
  }

  Future<LangOption?> _pickLanguage({
    required String title,
    required String currentCode,
  }) async {
    return showModalBottomSheet<LangOption>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        String query = "";
        bool showSearch = false;
        final searchFocus = FocusNode();

        return StatefulBuilder(
          builder: (context, setModalState) {
            final normalized = query.trim().toLowerCase();
            final filtered = normalized.isEmpty
                ? kLanguages
                : kLanguages
                    .where((e) =>
                        e.name.toLowerCase().contains(normalized) ||
                        e.code.toLowerCase().contains(normalized))
                    .toList();
            final current = kLanguages.firstWhere(
              (l) => l.code == currentCode,
              orElse: () => kLanguages.first,
            );
            final maxHeight = MediaQuery.of(context).size.height * 0.75;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Glass(
                  radius: BorderRadius.circular(26),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: SizedBox(
                    height: maxHeight,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                final nextShow = !showSearch;
                                setModalState(() {
                                  showSearch = nextShow;
                                  if (!nextShow) query = "";
                                });
                                if (nextShow) {
                                  Future.delayed(
                                    Duration.zero,
                                    () => searchFocus.requestFocus(),
                                  );
                                }
                              },
                              icon: Icon(
                                showSearch
                                    ? Icons.search_off_rounded
                                    : Icons.search_rounded,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: Icon(Icons.close_rounded,
                                  color: Colors.white.withValues(alpha: 0.85)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (showSearch) ...[
                          Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: T.fieldFill,
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12)),
                            ),
                            child: TextField(
                              focusNode: searchFocus,
                              onChanged: (v) =>
                                  setModalState(() => query = v),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              cursorColor: Colors.white,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: "Search language",
                                hintStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5)),
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search_rounded,
                                    color:
                                        Colors.white.withValues(alpha: 0.7)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (filtered.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              "No matches",
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        else
                          ...filtered.map((e) {
                            final selected = e.code == current.code;
                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => Navigator.pop(ctx, e),
                              child: Container(
                                height: 52,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: selected
                                      ? Colors.white.withValues(alpha: 0.10)
                                      : Colors.black.withValues(alpha: 0.10),
                                  border: Border.all(
                                    color: selected
                                        ? Colors.white.withValues(alpha: 0.26)
                                        : Colors.white.withValues(alpha: 0.10),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        e.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    if (selected)
                                      Icon(Icons.check_rounded,
                                          color:
                                              Colors.white.withValues(alpha: 0.9)),
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
      },
    );
  }

  bool _isMutedFor(String userId) =>
      circleVoiceService.voiceFor(userId)?.muted ?? false;
  bool _isSpeakingFor(String userId) =>
      circleVoiceService.voiceFor(userId)?.speaking ?? false;

  void _toggleMuteFor(String userId) {
    agoraVoiceService.toggleMuted();
  }

  Future<void> _connectVoice() async {
    final l10n = AppLocalizations.of(context);
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
    final l10n = AppLocalizations.of(context);
    final username = await _promptInviteUsername();
    if (username == null || username.isEmpty) return;

    try {
      final users = await socialRepository.searchUsers(username);
      if (!mounted) return;

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
      if (!mounted) return;

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
      if (!mounted) return;

      _toast(context, l10n.circlesInviteSent(username));
    } catch (e) {
      if (!mounted) return;
      _toast(context, l10n.circlesInviteFailed(e.toString()));
    }
  }

  void _openProfileSheet(String? userId) {
    if (userId == null || userId.isEmpty) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) {
        final size = MediaQuery.of(context).size;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: size.width > 440 ? 420 : size.width * 0.92,
              height: size.height * 0.74,
              child: ProfileScreen(userId: userId),
            ),
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
        final l10n = AppLocalizations.of(ctx);
        return AlertDialog(
          backgroundColor: Theme.of(ctx).colorScheme.surface,
          title: Text(
            l10n.circlesInviteByUsername,
            style: TextStyle(
                color: Theme.of(ctx).colorScheme.onSurface, fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(
                color: Theme.of(ctx).colorScheme.onSurface, fontWeight: FontWeight.w700),
            cursorColor: Theme.of(ctx).colorScheme.primary,
            decoration: InputDecoration(
              hintText: l10n.authUsername,
              hintStyle: TextStyle(color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.5)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel,
                  style: TextStyle(color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.75))),
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

  Future<void> _confirmMemberExit({required bool spectator}) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          backgroundColor: scheme.surface,
          title: Text(
            l10n.circlesLeavePromptTitle,
            style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w900),
          ),
          content: Text(
            spectator
                ? '${l10n.circlesSpectator} • ${l10n.leave}'
                : '${l10n.circlesParticipant} • ${l10n.leave}',
            style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.82)),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.leave)),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await circlesRepository.leaveCircle(widget.circleId);
    await circleVoiceService.disconnectIfCircle(widget.circleId);
    await agoraVoiceService.disconnectIfCircle(widget.circleId);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _requestJoin() async {
    final l10n = AppLocalizations.of(context);
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
    final l10n = AppLocalizations.of(context);
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
    final l10n = AppLocalizations.of(context);
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
    final l10n = AppLocalizations.of(context);
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
        final l10n = AppLocalizations.of(ctx);
        return AlertDialog(
          backgroundColor: Theme.of(ctx).colorScheme.surface,
          title: Text(
            l10n.circlesLeavePromptTitle,
            style: TextStyle(
                color: Theme.of(ctx).colorScheme.onSurface, fontWeight: FontWeight.w900),
          ),
          content: Text(
            canTransfer
                ? l10n.circlesLeavePromptTransfer
                : l10n.circlesLeavePromptEndOnly,
            style: TextStyle(
                color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.78),
                fontWeight: FontWeight.w600),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel,
                  style: TextStyle(color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.75))),
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
        final l10n = AppLocalizations.of(ctx);
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
                          style: TextStyle(
                              color: Theme.of(ctx).colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                              fontSize: 16),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: Icon(Icons.close_rounded,
                              color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.85)),
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
                            color: Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.12),
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.14)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person_rounded,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  c.name,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6)),
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
    final l10n = AppLocalizations.of(context);

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
          name: profile?['display_name'] ??
              profile?['username'] ??
              l10n.loading,
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

    return PopScope(
      canPop: !isHost,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (isHost) {
          await _handleHostExit();
        }
      },
      child: Scaffold(
        body: SafeArea(
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
                        _openLobbyActionsSheet();
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
                                      child: _editingLobbySettings
                                          ? _EditableSelectTile(
                                              label: l10n.iSpeak,
                                              value:
                                                  _languageName(_editSpeakLang),
                                              icon: Icons.record_voice_over_rounded,
                                              onTap: () async {
                                                final next =
                                                    await _pickLanguage(
                                                  title: l10n.chooseYourLanguage,
                                                  currentCode: _editSpeakLang,
                                                );
                                                if (next != null) {
                                                  setState(() => _editSpeakLang =
                                                      next.code);
                                                }
                                              },
                                            )
                                          : _PillInfo(
                                              icon: Icons.translate_rounded,
                                              title:
                                                  "${circleData!['from_lang']} → ${circleData!['to_lang']}",
                                              subtitle: l10n.circlesLanguages,
                                            ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _editingLobbySettings
                                          ? _EditableSelectTile(
                                              label: l10n.iWantToLearn,
                                              value:
                                                  _languageName(_editLearnLang),
                                              icon: Icons.translate_rounded,
                                              onTap: () async {
                                                final next =
                                                    await _pickLanguage(
                                                  title: l10n.chooseLearningLanguage,
                                                  currentCode: _editLearnLang,
                                                );
                                                if (next != null) {
                                                  setState(() => _editLearnLang =
                                                      next.code);
                                                }
                                              },
                                            )
                                          : _PillInfo(
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
                                      child: _editingLobbySettings
                                          ? _ModeToggle(
                                              leftLabel: l10n.soloModeVocabulary,
                                              leftValue: "Vocabulary",
                                              rightLabel: l10n.soloModeSentences,
                                              rightValue: "Sentences",
                                              value: _editMode,
                                              onChanged: (value) =>
                                                  setState(() => _editMode =
                                                      value),
                                            )
                                          : _PillInfo(
                                              icon: Icons.stacked_bar_chart_rounded,
                                              title: l10n
                                                  .circlesLevelWithValue(levelLabel),
                                              subtitle: l10n.circlesDifficulty,
                                            ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _editingLobbySettings
                                          ? _LevelPicker(
                                              level: _editLevel,
                                              onChanged: (value) =>
                                                  setState(() => _editLevel =
                                                      value),
                                            )
                                          : _PillInfo(
                                              icon: Icons.help_outline_rounded,
                                              title: l10n.questionsShort(
                                                  circleData!['questions_count'] ??
                                                      0),
                                              subtitle: l10n.circlesQuestions,
                                            ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _editingLobbySettings
                                          ? _HostSettingRow(
                                              title: l10n.circlesQuestions,
                                              value: "$_editQuestions",
                                              onMinus: _editQuestions > 5
                                                  ? () => setState(() =>
                                                      _editQuestions -= 5)
                                                  : null,
                                              onPlus: _editQuestions < 50
                                                  ? () => setState(() =>
                                                      _editQuestions += 5)
                                                  : null,
                                            )
                                          : _PillInfo(
                                              icon: Icons.timer_rounded,
                                              title: l10n.secondsShort(
                                                  circleData!['time_per_q'] ?? 0),
                                              subtitle: l10n.circlesPerQuestionShort,
                                            ),
                                    ),
                                  ],
                                ),

                                if (_editingLobbySettings) ...[
                                  const SizedBox(height: 10),
                                  _HostSettingRow(
                                    title: l10n.circlesTimePerQuestion,
                                    value: l10n.secondsShort(_editTimePerQ),
                                    onMinus: _editTimePerQ > 5
                                        ? () => setState(() =>
                                            _editTimePerQ -= 1)
                                        : null,
                                    onPlus: _editTimePerQ < 60
                                        ? () => setState(() =>
                                            _editTimePerQ += 1)
                                        : null,
                                  ),
                                ],

                                const SizedBox(height: 14),

                                // Simplified quick actions
                                Row(
                                  children: [
                                    if (!isSpectator) ...[
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
                                    roomLocked: circleData?['is_locked'] ?? false,
                                    isEditing: _editingLobbySettings,
                                    isSaving: _savingLobbySettings,
                                    onToggleLock: _toggleRoomLock,
                                    onEdit: _toggleLobbySettingsEdit,
                                    onCancel: _cancelLobbySettingsEdit,
                                  )
                                else if (isSpectator)
                                  _SpectatorTip()
                                else
                                  _PlayerTip(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),
                          _StatusCallout(
                            title: isHost
                                ? l10n.roleHost
                                : (isSpectator ? l10n.roleSpectator : l10n.circlesParticipant),
                            body: isHost
                                ? '${l10n.circlesStartGame} • ${l10n.circlesLeaveCircle}'
                                : (isSpectator
                                    ? '${l10n.circlesWatchLive} • ${l10n.leave}'
                                    : '${l10n.ready} • ${l10n.leave}'),
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
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
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
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62),
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
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
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
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62),
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
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
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
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62),
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
                                    onTap: () => _confirmMemberExit(spectator: true),
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
                                    onTap: () => _confirmMemberExit(spectator: false),
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
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
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
            child: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92), size: 22),
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
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92),
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
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.14),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9), size: 22),
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
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
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

class _EditableSelectTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _EditableSelectTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.12),
          border: Border.all(
              color:
                  Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
                size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.65),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.expand_more_rounded,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.65)),
          ],
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;
  final String value;
  final ValueChanged<String> onChanged;

  const _ModeToggle({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.14),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeChip(
              label: leftLabel,
              selected: value == leftValue,
              onTap: () => onChanged(leftValue),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ModeChip(
              label: rightLabel,
              selected: value == rightValue,
              onTap: () => onChanged(rightValue),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? const Color(0xFF2AFADF)
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? T.neonA.withValues(alpha: 0.2)
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? T.neonA.withValues(alpha: 0.45)
                : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelPicker extends StatelessWidget {
  final String level;
  final ValueChanged<String> onChanged;

  const _LevelPicker({
    required this.level,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.14),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _LevelChip(
              label: l10n.levelBeginner,
              selected: level == 'A',
              onTap: () => onChanged('A'),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _LevelChip(
              label: l10n.levelIntermediate,
              selected: level == 'B',
              onTap: () => onChanged('B'),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _LevelChip(
              label: l10n.levelAdvanced,
              selected: level == 'C',
              onTap: () => onChanged('C'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LevelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? T.neonA.withValues(alpha: 0.2)
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? T.neonA.withValues(alpha: 0.45)
                : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? const Color(0xFF2AFADF)
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.65),
              fontWeight: FontWeight.w800,
              fontSize: 11.5,
            ),
          ),
        ),
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
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.12),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
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

class _LobbyActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LobbyActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.black.withValues(alpha: 0.12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}

class _HostSettingRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const _HostSettingRow({
    required this.title,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: onMinus,
            icon: Icon(
              Icons.remove_circle_outline_rounded,
              color: onMinus == null
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          IconButton(
            onPressed: onPlus,
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: onPlus == null
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _HostControlsRow extends StatelessWidget {
  final bool roomLocked;
  final bool isEditing;
  final bool isSaving;
  final ValueChanged<bool> onToggleLock;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  const _HostControlsRow({
    required this.roomLocked,
    required this.isEditing,
    required this.isSaving,
    required this.onToggleLock,
    required this.onEdit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.14),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(Icons.admin_panel_settings_rounded,
              color: Theme.of(context).colorScheme.onSurface, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.circlesHostControls,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (isEditing)
            TextButton(
              onPressed: isSaving ? null : onCancel,
              child: Text(
                l10n.cancel,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          TextButton(
            onPressed: isSaving ? null : onEdit,
            child: Text(
              isEditing ? l10n.save : l10n.edit,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 6),
          Row(
            children: [
              Icon(Icons.lock_rounded,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75), size: 18),
              Switch(
                value: roomLocked,
                onChanged: onToggleLock,
                activeThumbColor: const Color(0xFF2AFADF),
                activeTrackColor: T.neonA.withValues(alpha: 0.25),
                inactiveThumbColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
                inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.18),
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
        color: Colors.black.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Tap Ready when you’re set. Host will start the match.",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.80),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(Icons.visibility_rounded,
              color: Colors.white.withValues(alpha: 0.85), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "You're spectating. Watch live once the host starts.",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.80),
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
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.10),
              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
            ),
            child: Icon(Icons.hourglass_top_rounded,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9), size: 20),
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
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.68),
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
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35);

    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: player.isEmpty ? 0.04 : 0.08)
            : Colors.black.withValues(alpha: player.isEmpty ? 0.08 : 0.14),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: player.isEmpty ? null : onAvatarTap,
            child: _AvatarDot(
              glow: player.isHost,
              empty: player.isEmpty,
              muted: player.isMuted,
              speaking: player.isSpeaking,
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
                          color: Theme.of(context).colorScheme.onSurface
                              .withValues(alpha: player.isEmpty ? 0.55 : 1),
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
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.10),
                          border:
                              Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.18)),
                        ),
                        child: Text(
                          "HOST",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
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
                            color: readyColor.withValues(alpha: 0.25),
                            blurRadius: 4,
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
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
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
                  color: Colors.black.withValues(alpha: 0.12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Icon(
                  player.isReady
                      ? Icons.check_rounded
                      : Icons.hourglass_bottom_rounded,
                  color: Colors.white.withValues(alpha: 0.88),
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
                  color: Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.12),
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
                ),
                child: Icon(Icons.close_rounded,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85)),
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
        muted ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55) : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92);
    final bg =
        muted ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08) : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: bg,
            border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
            boxShadow: speaking
                ? [
                    BoxShadow(
                      color: const Color(0xFF2AFADF).withValues(alpha: 0.25),
                      blurRadius: 8,
                      spreadRadius: 0,
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
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.12),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Icon(Icons.person_rounded, color: Theme.of(context).colorScheme.onSurface, size: 20),
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
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
            border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92), size: 20),
        ),
      ),
    );
  }
}

class _AvatarDot extends StatelessWidget {
  final bool glow;
  final bool empty;
  final bool muted;
  final bool speaking;

  const _AvatarDot({
    required this.glow,
    required this.empty,
    required this.muted,
    required this.speaking,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        empty ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.18) : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              if (glow)
                BoxShadow(
                  color: T.neonA.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              if (speaking && !empty)
                BoxShadow(
                  color: const Color(0xFF2AFADF).withValues(alpha: 0.35),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Center(
            child: Icon(
              empty ? Icons.person_outline_rounded : Icons.person_rounded,
              color: Colors.black.withValues(alpha: 0.70),
            ),
          ),
        ),
        if (!empty)
          Positioned(
            bottom: -1,
            right: -1,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: muted ? 0.55 : 0.9),
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
                  width: 1.5,
                ),
              ),
              child: Icon(
                muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                size: 10,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
      ],
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
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.12),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
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
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.16),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.16)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
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
