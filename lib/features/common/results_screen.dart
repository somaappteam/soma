import 'dart:async';
import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/soma_background.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../models/leaderboard_player.dart';
import '../../data/circle_voice_service.dart';
import '../../data/profile_store.dart';
import '../../data/agora_voice_service.dart';
import '../../data/circles_repository.dart';
import '../../data/quiz_repository.dart';
import '../circles/circle_countdown_screen.dart';
import '../circles/live_quiz_screen.dart';


class ResultsScreen extends StatefulWidget {
  const ResultsScreen({
    super.key,
    required this.points,
    required this.correct,
    required this.total,
    required this.rank,
    required this.playersCount,
    required this.playerName,
    required this.leaderboard,
    this.onPlayAgain,
    this.circleId,
  });

  final List<LeaderboardPlayer> leaderboard;
  final int points;
  final int correct;
  final int total;

  /// rank starts at 1 (1st place)
  final int rank;
  final int playersCount;
  final String playerName;
  final String? circleId;

  /// Optional: if you want to host another match quickly
  final VoidCallback? onPlayAgain;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _startingRematch = false;
  bool _didConnectVoice = false;
  StreamSubscription<Map<String, dynamic>>? _circleSub;
  bool _isNavigatingToQuiz = false;

  @override
  void initState() {
    super.initState();
    _listenCircleStatus();
  }

  void _listenCircleStatus() {
    if (widget.circleId == null) return;
    _circleSub?.cancel();
    _circleSub = circlesRepository.getCircleStream(widget.circleId!).listen((data) {
      if (!mounted) return;
      final status = data['status']?.toString();
      if (status == 'active' && !_isNavigatingToQuiz && !_isHostMe) {
        // Automatically join rematch
        _onRematchStarted(data);
      }
    });
  }

  void _onRematchStarted(Map<String, dynamic> circleData) {
    if (_isNavigatingToQuiz) return;
    _isNavigatingToQuiz = true;

    final questions = List<Map<String, dynamic>>.from(circleData['questions'] ?? []);
    final timePerQ = circleData['time_per_q'] ?? 10;

    Navigator.pushReplacement(
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
                  questions: questions,
                  timePerQ: timePerQ,
                  role: LiveQuizRole.participant,
                  circleId: widget.circleId,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didConnectVoice) return;
    _didConnectVoice = true;
    _connectVoice();
  }

  Future<void> _connectVoice() async {
    final circleId = widget.circleId;
    if (circleId == null) return;

    final l10n = AppLocalizations.of(context);
    final profile = profileStore.profile;
    final name = profile.displayName.isNotEmpty
        ? profile.displayName
        : (profile.username.isNotEmpty ? profile.username : l10n.userFallbackName);

    await circleVoiceService.connect(circleId: circleId, name: name);
    final isSpectator = widget.leaderboard.every((p) => !p.isMe);
    await agoraVoiceService.connect(circleId: circleId, asSpeaker: !isSpectator);
  }
  bool get _isHostMe {
    final me = widget.leaderboard.where((p) => p.isMe).toList();
    if (me.isEmpty) return false;
    return me.first.isHost;
  }

  Future<void> _startRematch() async {
    if (_startingRematch) return;
    final circleId = widget.circleId;
    if (circleId == null) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _startingRematch = true);

    try {
      final circle = await circlesRepository.getCircleDetails(circleId);
      if (circle == null) {
        throw Exception(l10n.circleNotFound);
      }

      final fromLang = circle['from_lang']?.toString() ?? '';
      final toLang = circle['to_lang']?.toString() ?? '';
      final mode = circle['mode']?.toString() ?? '';
      final questionsCount = circle['questions_count'] is int ? circle['questions_count'] as int : 10;
      final timePerQ = circle['time_per_q'] is int ? circle['time_per_q'] as int : 10;

      final courseId = "solo_${fromLang}_$toLang";
      List<Map<String, dynamic>> quizQuestions = [];
      if (mode == "Vocabulary") {
        quizQuestions = await quizRepository.getVocabQuestions(courseId, questionsCount);
      } else {
        quizQuestions = await quizRepository.getSentenceQuestions(courseId, questionsCount);
      }

      if (quizQuestions.isEmpty) {
        final existing = circle['questions'];
        if (existing is List) {
          quizQuestions = existing
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      }

      if (quizQuestions.isNotEmpty) {
        await circlesRepository.updateCircleQuestions(circleId, quizQuestions);
      }
      await circlesRepository.updateCircleStatus(circleId, 'active');
      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CircleCountdownScreen(
            seconds: 3,
            circleId: circleId,
            onFinished: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LiveQuizScreen(
                    questions: quizQuestions,
                    timePerQ: timePerQ,
                    role: LiveQuizRole.host,
                    circleId: circleId,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.resultsRematchStartFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _startingRematch = false);
      }
    }
  }

  @override
  void dispose() {
    _circleSub?.cancel();
    super.dispose();
  }

  double get accuracy => widget.total == 0 ? 0 : (widget.correct / widget.total);

  String _placeLabel(AppLocalizations l10n) {
    if (widget.rank == 1) return l10n.resultsPlaceFirst;
    if (widget.rank == 2) return l10n.resultsPlaceSecond;
    if (widget.rank == 3) return l10n.resultsPlaceThird;
    return l10n.resultsPlaceNth(widget.rank);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pct = (accuracy * 100).round();

    return Scaffold(
      body: SomaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // Top bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Title
                Text(
                  l10n.resultsMatchTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.resultsNiceWork(widget.playerName),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 18),

                // Main card
                Glass(
                  padding: const EdgeInsets.all(16),
                  radius: BorderRadius.circular(22),
                  child: Column(
                    children: [
                      // Place + points
                      Row(
                        children: [
                          _Badge(rank: widget.rank),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _placeLabel(l10n),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.resultsOutOfPlayers(widget.playersCount),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.60),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                l10n.pointsLabel,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "+${widget.points}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Accuracy bar
                      _AccuracyBar(percent: pct),

                      const SizedBox(height: 14),

                      // Stats row
                      Row(
                        children: [
                          Expanded(
                            child: _StatTile(
                              title: l10n.statCorrect,
                              value: "${widget.correct}",
                              subtitle: l10n.statAnswers,
                              icon: Icons.check_circle_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatTile(
                              title: l10n.statTotal,
                              value: "${widget.total}",
                              subtitle: l10n.statQuestions,
                              icon: Icons.quiz_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _StatTile(
                              title: l10n.statAccuracy,
                              value: "$pct%",
                              subtitle: l10n.statRate,
                              icon: Icons.track_changes_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatTile(
                              title: l10n.statRank,
                              value: "#${widget.rank}",
                              subtitle: l10n.statPosition,
                              icon: Icons.emoji_events_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Optional: a small highlight card
                Glass(
                  padding: const EdgeInsets.all(14),
                  radius: BorderRadius.circular(18),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.rank == 1
                              ? l10n.resultsHighlightChampion
                              : (pct >= 80
                                  ? l10n.resultsHighlightGreatAccuracy
                                  : l10n.resultsHighlightKeepGoing),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Leaderboard
                Glass(
                  padding: const EdgeInsets.all(14),
                  radius: BorderRadius.circular(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.leaderboard_rounded, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            l10n.resultsLeaderboardTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            l10n.resultsPlayersCount(widget.leaderboard.length),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      StreamBuilder<Map<String, VoicePresence>>(
                        stream: circleVoiceService.stream,
                        builder: (context, snapshot) {
                          final voiceByUser = snapshot.data ?? const <String, VoicePresence>{};
                          final sorted = _sortedLeaderboard(widget.leaderboard);

                          return Column(
                            children: sorted.asMap().entries.map((entry) {
                              final i = entry.key; // 0-based
                              final p = entry.value;
                              final rank = i + 1;
                              final voice = p.userId != null ? voiceByUser[p.userId] : null;
                              final muted = voice?.muted ?? p.isMuted;
                              final speaking = voice?.speaking ?? p.isSpeaking;

                              return Padding(
                                padding: EdgeInsets.only(bottom: i == sorted.length - 1 ? 0 : 10),
                                child: _LeaderboardRow(
                                  rank: rank,
                                  name: p.name,
                                  points: p.points,
                                  accuracyPct: p.accuracyPct,
                                  isMe: p.isMe,
                                  isHost: p.isHost,
                                  isMuted: muted,
                                  isSpeaking: speaking,
                                  lastAnswer: p.lastAnswer,
                                  onToggleMute: p.isMe ? agoraVoiceService.toggleMuted : null,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Bottom buttons
                NeonButton(
                  label: l10n.resultsBackToCircles,
                  onTap: () async {
                    if (widget.circleId != null) {
                      await circleVoiceService.disconnectIfCircle(widget.circleId);
                      await agoraVoiceService.disconnectIfCircle(widget.circleId);
                    }
                    if (context.mounted) {
                      Navigator.popUntil(context, (r) => r.settings.name == '/app' || r.isFirst);
                    }
                  },
                ),
                const SizedBox(height: 10),
                _SecondaryButton(
                  label: _isHostMe && widget.circleId != null
                      ? l10n.resultsRematch
                      : l10n.resultsPlayAgain,
                  onTap: _isHostMe && widget.circleId != null
                      ? () {
                          if (_startingRematch) return;
                          _startRematch();
                        }
                      : (widget.onPlayAgain ??
                          () {
                            // default: just go back to lobby
                            Navigator.pop(context);
                          }),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    final icon = rank == 1
        ? Icons.emoji_events_rounded
        : rank == 2
            ? Icons.workspace_premium_rounded
            : rank == 3
                ? Icons.military_tech_rounded
                : Icons.star_rounded;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _AccuracyBar extends StatelessWidget {
  const _AccuracyBar({required this.percent});
  final int percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final clamped = percent.clamp(0, 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.statAccuracy,
              style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              "$clamped%",
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 10,
            color: Colors.white.withValues(alpha: 0.10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: clamped / 100,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF35E7FF), Color(0xFF9A5BFF), Color(0xFFFF49D7)],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.black.withValues(alpha: 0.22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

List<LeaderboardPlayer> _sortedLeaderboard(List<LeaderboardPlayer> list) {
  final copy = List<LeaderboardPlayer>.from(list);
  copy.sort((a, b) {
    // Sort by points desc, then accuracy desc
    final byPoints = b.points.compareTo(a.points);
    if (byPoints != 0) return byPoints;
    return b.accuracyPct.compareTo(a.accuracyPct);
  });
  return copy;
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.rank,
    required this.name,
    required this.points,
    required this.accuracyPct,
    required this.isMe,
    required this.isHost,
    required this.isMuted,
    required this.isSpeaking,
    required this.lastAnswer,
    required this.onToggleMute,
  });

  final int rank;
  final String name;
  final int points;
  final int accuracyPct;
  final bool isMe;
  final bool isHost;
  final bool isMuted;
  final bool isSpeaking;
  final LeaderboardAnswer lastAnswer;
  final VoidCallback? onToggleMute;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isMe ? Colors.white.withValues(alpha: 0.10) : Colors.white.withValues(alpha: 0.06),
        border: Border.all(
          color: isMe ? Colors.white.withValues(alpha: 0.28) : Colors.white.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          _RowRankChip(rank: rank),
          const SizedBox(width: 10),
          _RowAvatarBubble(name: name),
          const SizedBox(width: 10),
          if (onToggleMute != null)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onToggleMute,
              child: _RowVoiceBadge(muted: isMuted, speaking: isSpeaking),
            )
          else
            _RowVoiceBadge(muted: isMuted, speaking: isSpeaking),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (isHost) ...[
                      const SizedBox(width: 6),
                      _RowTag(label: l10n.tagHost),
                    ],
                    if (isMe) ...[
                      const SizedBox(width: 6),
                      _RowTag(label: l10n.tagYou),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _RowAnswerIndicator(result: lastAnswer),
                    const SizedBox(width: 6),
                    Text(
                      lastAnswer == LeaderboardAnswer.correct
                          ? l10n.statusCorrect
                          : lastAnswer == LeaderboardAnswer.wrong
                              ? l10n.statusWrong
                              : l10n.statusNone,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$points",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.pointsAbbrev,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RowRankChip extends StatelessWidget {
  final int rank;

  const _RowRankChip({required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withValues(alpha: 0.18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      alignment: Alignment.center,
      child: Text(
        "#$rank",
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _RowAvatarBubble extends StatelessWidget {
  final String name;

  const _RowAvatarBubble({required this.name});

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isNotEmpty ? trimmed.substring(0, 1).toUpperCase() : "?";
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF2AFADF), Color(0xFF7C7CFF), Color(0xFFFF4ECD)],
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _RowVoiceBadge extends StatelessWidget {
  final bool muted;
  final bool speaking;

  const _RowVoiceBadge({required this.muted, required this.speaking});

  @override
  Widget build(BuildContext context) {
    final color = muted ? Colors.white.withValues(alpha: 0.55) : Colors.white.withValues(alpha: 0.92);
    final bg = muted ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.12);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: bg,
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            boxShadow: speaking
                ? [
                    BoxShadow(
                      color: const Color(0xFF2AFADF).withValues(alpha: 0.45),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            muted ? Icons.mic_off_rounded : Icons.mic_rounded,
            color: color,
            size: 18,
          ),
        ),
        if (speaking)
          Positioned(
            bottom: 4,
            right: 4,
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

class _RowAnswerIndicator extends StatelessWidget {
  final LeaderboardAnswer result;

  const _RowAnswerIndicator({required this.result});

  @override
  Widget build(BuildContext context) {
    final isCorrect = result == LeaderboardAnswer.correct;
    final isWrong = result == LeaderboardAnswer.wrong;
    final color = isCorrect
        ? const Color(0xFF2AFADF)
        : isWrong
            ? const Color(0xFFFF4FD8)
            : Colors.white.withValues(alpha: 0.35);

    final icon = isCorrect
        ? Icons.check_rounded
        : isWrong
            ? Icons.close_rounded
            : Icons.circle_outlined;

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: isCorrect || isWrong ? 0.12 : 0.06),
        border: Border.all(color: color.withValues(alpha: isCorrect || isWrong ? 0.8 : 0.4)),
      ),
      child: Center(
        child: Icon(icon, size: 12, color: color),
      ),
    );
  }
}

class _RowTag extends StatelessWidget {
  final String label;

  const _RowTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 9.5,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
