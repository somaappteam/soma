import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/services/haptics_service.dart';
import 'widgets/circle_chat_sheet.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/theme/motion.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/premium_dialog.dart';
import '../../core/widgets/neon_button.dart';

import '../../core/widgets/responsive.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/staggered_in.dart';
import '../../core/widgets/reward_sparkle.dart';
import '../common/results_screen.dart';
import '../../models/leaderboard_player.dart';
import '../../data/circles_repository.dart';
import '../../data/circle_chat_repository.dart';
import '../../data/circle_voice_service.dart';
import '../../data/settings_repository.dart';
import '../../data/profile_repository.dart';
import '../../data/profile_store.dart';
import '../../data/agora_voice_service.dart';
import '../../core/services/tts_service.dart';
import '../profile/profile_screen.dart';

enum LiveQuizRole { host, participant, spectator }

class LiveQuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final int timePerQ;
  final LiveQuizRole role;
  final String? circleId;
  final bool joinRequested;
  
  const LiveQuizScreen({
    super.key, 
    this.questions = const [], 
    this.timePerQ = 10,
    this.role = LiveQuizRole.participant,
    this.circleId,
    this.joinRequested = false,
  });

  @override
  State<LiveQuizScreen> createState() => _LiveQuizScreenState();
}

class _LiveQuizScreenState extends State<LiveQuizScreen> {
  static const double _leaderChipWidth = 48;
  static const double _leaderChipHeight = 58;
  static const double _leaderChipSpacing = 8;


  late List<_Question> questions;
  StreamSubscription<Map<String, VoicePresence>>? _voiceSub;
  StreamSubscription<List<Map<String, dynamic>>>? _participantsSub;
  bool _initialized = false;
  late String _waitingForHostText;
  Map<String, Map<String, dynamic>> profilesCache = {};


  bool get isHost => widget.role == LiveQuizRole.host;
  bool get isParticipant => widget.role == LiveQuizRole.participant;
  bool get isSpectator => widget.role == LiveQuizRole.spectator;
  bool get canPlay => isHost || isParticipant;
  bool get canRequestJoin => widget.circleId != null && !_joinRequested;

  late bool _joinRequested;
  bool showReading = true;
  bool showTranslation = true;
  
  @override
  void initState() {
    super.initState();
    _joinRequested = widget.joinRequested;
    _loadSettings();
    _listenParticipants();
    _connectVoice();
  }

  Future<void> _loadSettings() async {
    final settings = await settingsRepository.getSettings();
    final readingSetting = settings['show_reading'];
    final translationSetting = settings['show_translation'];
    if (!mounted) return;
    setState(() {
      if (readingSetting is bool) showReading = readingSetting;
      if (translationSetting is bool) showTranslation = translationSetting;
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final l10n = AppLocalizations.of(context);
    _waitingForHostText = l10n.liveQuizWaitingForHost;
    
    // DEBUG: Log incoming questions
    debugPrint('=== LiveQuizScreen.didChangeDependencies ===');
    debugPrint('Received questions count: ${widget.questions.length}');
    if (widget.questions.isNotEmpty) {
      debugPrint('First received question: ${widget.questions.first}');
    }
    
    if (widget.questions.isNotEmpty) {
      try {
        questions = widget.questions.map((q) {
          // Robust parsing of 'correct' field - might be int or string from JSONB
          int correctIndex = 0;
          if (q['correct'] is int) {
            correctIndex = q['correct'] as int;
          } else if (q['correct'] is String) {
            correctIndex = int.tryParse(q['correct'] as String) ?? 0;
          }
          
          return _Question(
            prompt: q['prompt']?.toString() ?? '',
            choices: (q['choices'] as List?)?.map((e) => e.toString()).toList() ?? const [],
            correctIndex: correctIndex,
            translation: q['translation']?.toString() ?? '',
            reading: q['reading']?.toString() ?? '',
            fullSentence: q['full_sentence']?.toString() ?? '',
            article: q['article']?.toString() ?? '',
           word: q['word']?.toString() ?? '',
            gender: q['gender']?.toString() ?? '',
            correctAnswer: q['correct_answer']?.toString() ?? '',
            choicePool: (q['choice_pool'] as List?)?.map((e) => e.toString()).toList() ?? const [],
          );
        }).toList();
        debugPrint('✅ Successfully processed ${questions.length} questions');
      } catch (e, stackTrace) {
        debugPrint('❌ Error parsing questions: $e');
        debugPrint('Stack trace: $stackTrace');
        questions = const [];
      }
    } else {
      debugPrint('No questions received');
      questions = const [];
    }

    if (questions.isNotEmpty) {
      _prepareQuestion();
      _startTimer();
    }
    _initialized = true;
  }

  void _listenParticipants() {
    if (widget.circleId == null) return;
    _participantsSub?.cancel();
    _participantsSub = circlesRepository.getParticipantsStream(widget.circleId!).listen((data) async {
      // 1. Fetch profiles for new user IDs
      final userIds = data.map((e) => e['user_id'] as String).toList();
      final newIds = userIds.where((id) => !profilesCache.containsKey(id)).toList();
      
      if (newIds.isNotEmpty) {
        final profiles = await profileRepository.getProfilesByIds(newIds);
        for (var p in profiles) {
          profilesCache[p['id']] = p;
        }
      }

      if (!mounted) return;

      final myId = circlesRepository.currentUserId;
      final updatedLeaders = data.map((p) {
        final uid = p['user_id']?.toString();
        final profile = profilesCache[uid];
        final role = p['role']?.toString();
        final score = p['score'] is int ? p['score'] as int : int.tryParse(p['score']?.toString() ?? '0') ?? 0;
        final isMe = uid != null && uid == myId;

        // If it's me, update my local score tracker too
        if (isMe) {
          myScore = score;
        }

        return _Leader(
          profile?['display_name'] ?? profile?['username'] ?? AppLocalizations.of(context).userFallbackName,
          score,
          isMe,
          correct: 0, // We could track correct answers in DB too, but score is enough for leaderboard
          total: 0,
          isHost: role == 'host',
          isMuted: _isMutedFor(uid ?? ''),
          isSpeaking: _isSpeakingFor(uid ?? ''),
          userId: uid,
          avatarUrl: profile?['avatar_url']?.toString(),
        );
      }).toList();

      setState(() {
        leaders = updatedLeaders;
      });
    });
  }

  bool _isMutedFor(String userId) => circleVoiceService.voiceFor(userId)?.muted ?? false;
  bool _isSpeakingFor(String userId) => circleVoiceService.voiceFor(userId)?.speaking ?? false;


  Future<void> _connectVoice() async {
    final circleId = widget.circleId;
    if (circleId == null) return;

    final l10n = AppLocalizations.of(context);
    final profile = profileStore.profile;
    final name = profile.displayName.isNotEmpty
        ? profile.displayName
        : (profile.username.isNotEmpty ? profile.username : l10n.userFallbackName);

    try {
      await circleVoiceService.connect(circleId: circleId, name: name);
      await agoraVoiceService.connect(circleId: circleId, asSpeaker: !isSpectator);
    } catch (e) {
      debugPrint('Error connecting to voice services: $e');
      // Continue without voice if it fails
    }
    _voiceSub?.cancel();
    _voiceSub = circleVoiceService.stream.listen((voiceByUser) {
      if (!mounted) return;
      setState(() {
        leaders = leaders.map((l) {
          final uid = l.userId;
          if (uid == null) return l;
          final voice = voiceByUser[uid];
          if (voice == null) return l;
          return l.copyWith(
            isMuted: voice.muted,
            isSpeaking: voice.speaking,
          );
        }).toList();
      });
    });
  }

  int qIndex = 0;
  int? selectedIndex;
  bool revealed = false;
  List<String> _choices = [];
  int _correctIndex = 0;
  double _speechRate = 1.0;
  Timer? _ttsTimer;
  final Map<String, int> _answersByUser = {};
  final Map<String, int> _answerTimeByUser = {};

  // Timer per question
  late int t;
  Timer? timer;

  // Score state
  int myScore = 0;

  // Leaderboard state
  List<_Leader> leaders = [];



  @override
  void dispose() {
    timer?.cancel();
    _participantsSub?.cancel();
    _voiceSub?.cancel();
    _ttsTimer?.cancel();
    ttsService.stop();
    super.dispose();
  }

  void _startTimer() {
    debugPrint('Starting quiz timer: ${widget.timePerQ}s');
    timer?.cancel();
    setState(() => t = widget.timePerQ);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (t <= 1) {
        timer?.cancel();
        _revealAnswer(timedOut: true);
      } else {
        setState(() => t -= 1);
      }
    });
  }

  void _select(int idx) {
    if (revealed || (!isParticipant && !isHost)) return;
    final meKey = _currentUserKey;
    if (meKey == null || _answersByUser.containsKey(meKey)) return;
    hapticsService.selectionClick();
    setState(() => selectedIndex = idx);
    _recordAnswer(meKey, idx);
  }

  Future<void> _requestJoin() async {
    final circleId = widget.circleId;
    if (circleId == null || _joinRequested) return;
    final l10n = AppLocalizations.of(context);
    try {
      await circlesRepository.requestToJoin(circleId);
      if (!mounted) return;
      setState(() => _joinRequested = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.liveQuizJoinRequestSent)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.liveQuizJoinRequestFailed(e.toString()))),
      );
    }
  }

  void _toggleMuteFor(String name) {
    agoraVoiceService.toggleMuted();
  }

  void _revealAnswer({bool timedOut = false}) async {
    if (revealed) return;
    timer?.cancel();
    final q = questions[qIndex];

    final meKey = _currentUserKey;
    final myAnswerIndex = _answersByUser[meKey];
    final myAnswerCorrect = myAnswerIndex != null && myAnswerIndex == _correctIndex;
    if (myAnswerIndex != null) {
      if (myAnswerCorrect) {
        hapticsService.mediumImpact();
      } else {
        hapticsService.lightImpact();
      }
    }
    
    int newScore = myScore;
    if (myAnswerCorrect) {
      final answerTime = _answerTimeByUser[meKey] ?? 0;
      final gained = 100 + (answerTime * 3);
      newScore += gained;
      
      // Sync score to Supabase
      if (widget.circleId != null) {
        await circlesRepository.updateParticipantScore(widget.circleId!, newScore);
      }
    }

    if (!mounted) return;

    setState(() {
      revealed = true;
      // We don't manually update 'leaders' here because the participant stream 
      // will trigger an update as soon as the score is written to DB.
      // But we update lastAnswer for local UI feedback
      leaders = leaders.map((l) {
        final key = _leaderKey(l);
        final answerIndex = _answersByUser[key];
        final didAnswer = answerIndex != null;
        final answeredCorrect = didAnswer && answerIndex == _correctIndex;
        
        return l.copyWith(
          lastAnswer: didAnswer
              ? (answeredCorrect ? LeaderboardAnswer.correct : LeaderboardAnswer.wrong)
              : (timedOut ? LeaderboardAnswer.wrong : LeaderboardAnswer.none),
        );
      }).toList();
    });

    if (_isSentenceQuestion(q)) {
      _speakSentence(q).whenComplete(() {
        if (!mounted) return;
        _next();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        _next();
      });
    }
  }

  void _next() {
    if (qIndex >= questions.length - 1) {
      _goToResults();
      return;
    }
    setState(() {
      qIndex += 1;
      selectedIndex = null;
      revealed = false;
      _answersByUser.clear();
      _answerTimeByUser.clear();
      leaders = leaders.map((l) => l.copyWith(lastAnswer: LeaderboardAnswer.none)).toList();
    });
    if (questions.isNotEmpty) {
      _prepareQuestion();
      _startTimer();
    }
  }

  void _prepareQuestion() {
    if (questions.isEmpty) return;
    final q = questions[qIndex];
    
    debugPrint('=== _prepareQuestion ===');
    debugPrint('qIndex: $qIndex, Total questions: ${questions.length}');
    debugPrint('Current question prompt: "${q.prompt}"');
    debugPrint('Current question choices: ${q.choices}');
    
    final choiceSet = _buildChoiceSet(q);
    setState(() {
      _choices = choiceSet.choices;
      _correctIndex = choiceSet.correctIndex;
    });
    _scheduleQuestionAudio(q);
  }

  _ChoiceSet _buildChoiceSet(_Question question) {
    if (question.choicePool.isNotEmpty && question.correctAnswer.isNotEmpty) {
      final items = question.choicePool
          .where((value) => value.trim().isNotEmpty && value != question.correctAnswer)
          .toSet()
          .toList();
      items.shuffle();
      final choices = <String>[question.correctAnswer, ...items.take(3)];
      choices.shuffle();
      return _ChoiceSet(choices: choices, correctIndex: choices.indexOf(question.correctAnswer));
    }
    return _ChoiceSet(choices: question.choices, correctIndex: question.correctIndex);
  }

  bool _isSentenceQuestion(_Question question) => question.fullSentence.trim().isNotEmpty;

  void _scheduleQuestionAudio(_Question question) {
    if (_isSentenceQuestion(question)) return;
    final prompt = question.prompt.trim();
    if (prompt.isEmpty || prompt == _waitingForHostText) return;
    _ttsTimer?.cancel();
    _ttsTimer = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      ttsService.setRate(_speechRate);
      ttsService.speak(prompt);
    });
  }

  Future<void> _speakSentence(_Question question, {bool withDelay = true}) {
    if (!_isSentenceQuestion(question)) return Future.value();
    final sentence = question.fullSentence.trim();
    if (sentence.isEmpty) return Future.value();
    final completer = Completer<void>();
    final delay = withDelay ? const Duration(milliseconds: 300) : Duration.zero;
    _ttsTimer?.cancel();
    _ttsTimer = Timer(delay, () async {
      if (!mounted) {
        completer.complete();
        return;
      }
      await ttsService.setRate(_speechRate);
      await ttsService.speak(sentence);
      completer.complete();
    });
    return completer.future;
  }

  void _onSpeakTap(_Question question) {
    if (_isSentenceQuestion(question)) {
      if (!revealed) return;
      _speakSentence(question, withDelay: false);
      return;
    }
    final prompt = question.prompt.trim();
    if (prompt.isEmpty) return;
    ttsService.setRate(_speechRate);
    ttsService.speak(prompt);
  }

  String _leaderKey(_Leader leader) => leader.userId ?? leader.name;

  bool _isAnsweringLeader(_Leader leader) => leader.isHost || leader.userId != null; // Host and all participants with IDs are players

  bool _allParticipantsAnswered() {
    final expected = leaders
        .where(_isAnsweringLeader)
        .map(_leaderKey)
        .toSet();
    if (expected.isEmpty) return false;
    return expected.every(_answersByUser.containsKey);
  }

  String? get _currentUserKey {
    final me = leaders.where((l) => l.isMe).toList();
    if (me.isEmpty) return null;
    return _leaderKey(me.first);
  }

  void _recordAnswer(String key, int index) {
    if (_answersByUser.containsKey(key)) return;
    _answersByUser[key] = index;
    _answerTimeByUser[key] = t;
    if (_allParticipantsAnswered()) {
      _revealAnswer();
    }
  }


  Future<void> _goToResults() async {
    if (isHost && widget.circleId != null) {
      await circlesRepository.updateCircleStatus(widget.circleId!, 'lobby');
    }
    if (!mounted) return;
    // Convert local leaders to LeaderboardPlayer
    final List<LeaderboardPlayer> finalLeaders = leaders.map((l) {
      return LeaderboardPlayer(
        userId: l.userId,
        name: l.name,
        points: l.score,
        correct: l.correct,
        total: l.total,
        isMe: l.isMe,
        isHost: l.isHost,
        isMuted: l.isMuted,
        isSpeaking: l.isSpeaking,
        lastAnswer: l.lastAnswer,
      );
    }).toList();

    // Sort to find my rank
    final sorted = List<LeaderboardPlayer>.from(finalLeaders);
    sorted.sort((a, b) => b.points.compareTo(a.points));

    final meIndex = sorted.indexWhere((p) => p.isMe);
    final me = meIndex != -1 ? sorted[meIndex] : sorted.first;
    final rank = meIndex + 1;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          points: me.points,
          correct: me.correct,
          total: me.total,
          rank: rank,
          playersCount: parsedPlayers,
          playerName: me.name,
          leaderboard: finalLeaders,
          onPlayAgain: () => Navigator.pop(context),
          circleId: widget.circleId,
        ),
      ),
    );
  }

  int get parsedPlayers => leaders.length;

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

  Future<void> _confirmExitCircle() async {
    final circleId = widget.circleId;
    if (circleId == null) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final l10n = AppLocalizations.of(context);
    final isHostUser = isHost;
    final confirmed = await showPremiumDialog(
      context: context,
      title: l10n.circlesLeavePromptTitle,
      body: isHostUser
          ? l10n.circlesLeavePromptEndOnly
          : (isSpectator
              ? '${l10n.circlesSpectator} • ${l10n.leave}'
              : '${l10n.circlesParticipant} • ${l10n.leave}'),
      cancelText: l10n.cancel,
      confirmText: isHostUser ? l10n.circlesEndCircle : l10n.leave,
      destructive: true,
    );

    if (confirmed != true) return;

    timer?.cancel();
    if (isHostUser) {
      await circlesRepository.endCircle(circleId);
    }
    await circlesRepository.leaveCircle(circleId);
    await circleVoiceService.disconnectIfCircle(circleId);
    await agoraVoiceService.disconnectIfCircle(circleId);
    if (!mounted) return;
    Navigator.popUntil(context, (r) => r.isFirst);
  }

  void _openChatSheet() {
    if (widget.circleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).circlesLiveChatUnavailable)),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final height = MediaQuery.of(context).size.height * 0.75;
        return SizedBox(
          height: height,
          child: CircleChatSheet(
            circleId: widget.circleId!,
            meId: circlesRepository.currentUserId,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    if (questions.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: ResponsiveFrame(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Center(
                child: Glass(
                  radius: BorderRadius.circular(24),
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    _waitingForHostText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    final q = questions[qIndex];
    final totalQuestions = questions.length;
    final progress = widget.timePerQ <= 0
        ? 1.0
        : (t / widget.timePerQ).clamp(0.0, 1.0);
    final hasTranslation = q.translation.trim().isNotEmpty;
    final showReadingLine = showReading && q.reading.trim().isNotEmpty && (!hasTranslation || revealed);
    final showTranslationLine = showTranslation && hasTranslation;
    
    // Sort leaders for leaderboard
    final sortedLeaders = List<_Leader>.from(leaders)
      ..sort((a, b) => b.score.compareTo(a.score));
      
    _Leader? meLeader;
    for (final leader in sortedLeaders) {
      if (leader.isMe) {
        meLeader = leader;
        break;
      }
    }
    
    final meKey = _currentUserKey;
    final isLocked = meKey != null && _answersByUser.containsKey(meKey);
    final roleLabel = isHost
        ? l10n.roleHost
        : (isSpectator ? l10n.roleSpectator : l10n.circlesParticipant);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveFrame(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              children: [
                // Top Bar
                Row(
                  children: [
                    _IconGlass(
                      icon: Icons.close_rounded,
                      onTap: _confirmExitCircle,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            roleLabel,
                            style: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Q${qIndex + 1} • 0:${t.toString().padLeft(2, "0")}",
                            style: TextStyle(
                                color: scheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                       )
                    ),
                     _Pill(
                        text: "$myScore",
                        icon: Icons.bolt_rounded,
                        color: const Color(0xFFF9F319),
                     ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                 // Timer Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: SizedBox(
                    height: 6,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: scheme.onSurface.withValues(alpha: 0.10),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.lerp(const Color(0xFF33D6FF),
                            const Color(0xFFFF4BD8), 1.0 - progress)!,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Leaderboard
                Glass(
                  radius: BorderRadius.circular(18),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: _LiveLeaderboardStrip(
                    leaders: sortedLeaders,
                    onAvatarTap: (leader) {
                      if (leader.userId != null) {
                        _openProfileSheet(leader.userId);
                      }
                    },
                  ),
                ),
                  
                const SizedBox(height: 12),

                // Question Card (Flexible)
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 200),
                  child: Glass(
                    radius: BorderRadius.circular(22),
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Column(
                      children: [
                        if (_isSentenceQuestion(q))
                            Text(
                              q.prompt,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: scheme.onSurface,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                height: 1.25,
                              ),
                            )
                          else
                            _VocabPromptLine(
                              prompt: q.prompt,
                              article: q.article,
                              word: q.word,
                              gender: q.gender,
                            ),
                          if (showReadingLine) ...[
                            const SizedBox(height: 8),
                            Text(
                              q.reading,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.55),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                          if (showTranslationLine) ...[
                            const SizedBox(height: 10),
                            Text(
                              q.translation,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.80),
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                _TtsControls(
                    rates: const [0.75, 1.0, 1.25],
                    selectedRate: _speechRate,
                    onRateSelected: (rate) {
                      setState(() => _speechRate = rate);
                      ttsService.setRate(rate);
                    },
                    onSpeak: () => _onSpeakTap(q),
                    disabled: _isSentenceQuestion(q) && !revealed,
                  ),

                const SizedBox(height: 16),
                
                 // Answers
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _choices.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final isSelected = selectedIndex == i;
                        final isCorrect = _correctIndex == i;
                        final showCorrect = revealed;
                        
                        // Neon styling from Solo layout
                        Color bg = scheme.onSurface.withValues(alpha: 0.06);
                        Color border = scheme.onSurface.withValues(alpha: 0.14);

                        if (showCorrect) {
                           if (isCorrect) {
                            bg = const Color(0xFF2AFADF).withValues(alpha: 0.14);
                            border = const Color(0xFF2AFADF).withValues(alpha: 0.85);
                          } else if (isSelected) {
                            bg = const Color(0xFFFF4FD8).withValues(alpha: 0.12);
                            border = const Color(0xFFFF4FD8).withValues(alpha: 0.85);
                          }
                        } else {
                           if (isSelected) {
                            bg = scheme.onSurface.withValues(alpha: 0.12);
                            border = scheme.onSurface.withValues(alpha: 0.28);
                          }
                        }

                        return StaggeredIn(
                          index: i,
                          child: PressableScale(
                            onTap: (canPlay && !isLocked && !revealed) ? () => _select(i) : null,
                            child: AnimatedScale(
                              scale: showCorrect && isCorrect ? 1.02 : 1,
                              duration: MotionTokens.short,
                              curve: MotionTokens.standardCurve,
                              child: AnimatedContainer(
                                duration: MotionTokens.short,
                                curve: MotionTokens.standardCurve,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: bg,
                                  border: Border.all(color: border),
                                  boxShadow: showCorrect && isCorrect
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF2AFADF).withValues(alpha: 0.35),
                                            blurRadius: 16,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                     Expanded(
                                      child: Text(
                                        _choices[i],
                                        style: TextStyle(
                                            color: scheme.onSurface.withValues(alpha: 0.92),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    if (showCorrect && isCorrect) ...[
                                      const Icon(Icons.check_rounded, color: Color(0xFF2AFADF)),
                                      const SizedBox(width: 6),
                                      const RewardSparkle(show: true),
                                    ] else if (showCorrect && isSelected && !isCorrect)
                                      const Icon(Icons.close_rounded, color: Color(0xFFFF4FD8))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 12),

                // CTA (Spectator Join / Bottom Bar)
                if (isSpectator) ...[
                    NeonButton(
                      label: _joinRequested ? l10n.liveQuizRequestSent : l10n.liveQuizRequestToJoin,
                      onTap: canRequestJoin ? _requestJoin : null,
                    ),
                    const SizedBox(height: 10),
                    _SpectatorFooter(),
                  ],

                  if (!isSpectator) ...[
                       Glass(
                        radius: BorderRadius.circular(18),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: _BottomActionBar(
                          isMuted: meLeader?.isMuted ?? false,
                          isSpeaking: meLeader?.isSpeaking ?? false,
                          readingEnabled: showReading,
                          onToggleMute: canPlay ? () => _toggleMuteFor(meLeader?.name ?? '') : null,
                          onOpenChat: _openChatSheet,
                          onToggleReading: () => setState(() => showReading = !showReading),
                        ),
                      ),
                  ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TinyGlass extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _TinyGlass({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class _LiveLeaderboardStrip extends StatelessWidget {
  final List<_Leader> leaders;
  final ValueChanged<_Leader>? onAvatarTap;

  const _LiveLeaderboardStrip({required this.leaders, this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    if (leaders.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalWidth =
        (leaders.length * (_LiveQuizScreenState._leaderChipWidth + _LiveQuizScreenState._leaderChipSpacing)) + 16;

    return SizedBox(
      height: _LiveQuizScreenState._leaderChipHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: SizedBox(
          width: max(MediaQuery.of(context).size.width, totalWidth),
          child: Stack(
            clipBehavior: Clip.none,
            children: leaders.asMap().entries.map((entry) {
              final index = entry.key;
              final leader = entry.value;
              // Center the strip if items are few
              final startOffset = max(0.0, (MediaQuery.of(context).size.width - totalWidth) / 2) + 16;

              return AnimatedPositioned(
                key: ValueKey('strip-${leader.userId ?? leader.name}'),
                duration: MotionTokens.medium,
                curve: MotionTokens.movementCurve,
                left: startOffset + (index * (_LiveQuizScreenState._leaderChipWidth + _LiveQuizScreenState._leaderChipSpacing)),
                top: 0,
                child: _CompactLeaderChip(
                  rank: index + 1,
                  leader: leader,
                  onTap: onAvatarTap == null ? null : () => onAvatarTap!(leader),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _CompactLeaderChip extends StatelessWidget {
  final int rank;
  final _Leader leader;
  final VoidCallback? onTap;

  const _CompactLeaderChip({required this.rank, required this.leader, this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderColor = leader.isMe
        ? const Color(0xFF33D6FF)
        : Colors.white.withValues(alpha: 0.2);
    
    Color? statusColor;
    IconData? statusIcon;
    
    if (leader.lastAnswer == LeaderboardAnswer.correct) {
      statusColor = const Color(0xFF2AFADF);
      statusIcon = Icons.check;
    } else if (leader.lastAnswer == LeaderboardAnswer.wrong) {
      statusColor = const Color(0xFFFF4FD8);
      statusIcon = Icons.close;
    }

    return SizedBox(
      width: _LiveQuizScreenState._leaderChipWidth,
      child: PressableScale(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: 1.5),
                      boxShadow: leader.isMe ? [
                        BoxShadow(
                          color: const Color(0xFF33D6FF).withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ] : null,
                    ),
                    child: _AvatarBubble(
                      name: leader.name,
                      heroTag: leader.userId == null ? null : "profile-avatar-${leader.userId}",
                      muted: leader.isMuted,
                      speaking: leader.isSpeaking,
                      avatarUrl: leader.avatarUrl,
                      size: 32,
                    ),
                  ),
                  if (statusColor != null)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Icon(statusIcon, size: 10, color: Colors.black),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              leader.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: leader.isMe ? const Color(0xFF33D6FF) : Colors.white.withValues(alpha: 0.9),
                fontWeight: leader.isMe ? FontWeight.w800 : FontWeight.w600,
                fontSize: 9,
              ),
            ),
             Text(
                '${leader.score}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 8,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final bool isMuted;
  final bool isSpeaking;
  final bool readingEnabled;
  final VoidCallback? onToggleMute;
  final VoidCallback onOpenChat;
  final VoidCallback onToggleReading;

  const _BottomActionBar({
    required this.isMuted,
    required this.isSpeaking,
    required this.readingEnabled,
    required this.onToggleMute,
    required this.onOpenChat,
    required this.onToggleReading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleActionButton(
          icon: readingEnabled ? Icons.text_fields_rounded : Icons.text_fields_outlined,
          onTap: onToggleReading,
        ),
        const SizedBox(width: 10),
        _CircleActionButton(
          icon: Icons.chat_bubble_rounded,
          onTap: onOpenChat,
        ),
        const SizedBox(width: 10),
        _CircleActionButton(
          icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
          onTap: onToggleMute,
          highlight: isSpeaking,
        ),
      ],
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool highlight;

  const _CircleActionButton({
    required this.icon,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          boxShadow: highlight
              ? [
                  BoxShadow(
                    color: const Color(0xFF2AFADF).withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Icon(icon, color: Colors.white.withValues(alpha: 0.95), size: 20),
      ),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  final String name;
  final String? heroTag;
  final bool muted;
  final bool speaking;
  final String? avatarUrl;
  final double size;

  const _AvatarBubble({
    required this.name,
    this.heroTag,
    required this.muted,
    required this.speaking,
    this.avatarUrl,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isNotEmpty ? trimmed.substring(0, 1).toUpperCase() : "?";
    final avatar = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: T.neonGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
              if (speaking)
                BoxShadow(
                  color: const Color(0xFF2AFADF).withValues(alpha: 0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: ClipOval(
            child: (avatarUrl != null && avatarUrl!.trim().isNotEmpty)
                ? Image.network(
                    avatarUrl!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
          ),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: muted ? 0.6 : 0.95),
              border: Border.all(color: Colors.black.withValues(alpha: 0.2), width: 1),
            ),
            child: Icon(
              muted ? Icons.mic_off_rounded : Icons.mic_rounded,
              size: 9,
              color: Colors.black.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );

    if (heroTag == null) {
      return avatar;
    }

    return Hero(tag: heroTag!, child: avatar);
  }
}

class _RolePill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _RolePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.92), size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}



class _SpectatorFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Icon(Icons.visibility_rounded, color: Colors.white.withValues(alpha: 0.9), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocalizations.of(context).liveQuizSpectatorFooter,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizProgressBar extends StatelessWidget {
  final double progress;
  const _QuizProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress.clamp(0, 1),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: T.neonGradient,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _AnswerState { normal, correct, wrong }



class _Question {
  final String prompt;
  final List<String> choices;
  final int correctIndex;
  final String translation;
  final String reading;
  final String fullSentence;
  final String article;
  final String word;
  final String gender;
  final List<String> choicePool;
  final String correctAnswer;

  const _Question({
    required this.prompt,
    required this.choices,
    required this.correctIndex,
    this.translation = '',
    this.reading = '',
    this.fullSentence = '',
    this.article = '',
    this.word = '',
    this.gender = '',
    this.choicePool = const [],
    this.correctAnswer = '',
  });
}

class _TtsControls extends StatelessWidget {
  final List<double> rates;
  final double selectedRate;
  final ValueChanged<double> onRateSelected;
  final VoidCallback onSpeak;
  final bool disabled;

  const _TtsControls({
    required this.rates,
    required this.selectedRate,
    required this.onRateSelected,
    required this.onSpeak,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = disabled ? 0.5 : 1.0;
    return Opacity(
      opacity: opacity,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            ...rates.map((rate) {
              final selected = rate == selectedRate;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _SpeedChip(
                  label: "${rate.toStringAsFixed(rate == 1.0 ? 0 : 2)}x",
                  selected: selected,
                  onTap: disabled ? null : () => onRateSelected(rate),
                ),
              );
            }),
            const Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: disabled ? null : onSpeak,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.volume_up_rounded, 
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _SpeedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? Colors.white.withValues(alpha: 0.16) : Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: selected ? Colors.white.withValues(alpha: 0.32) : Colors.white.withValues(alpha: 0.16)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),
        ),
      ),
    );
  }
}

class _VocabPromptLine extends StatelessWidget {
  final String prompt;
  final String article;
  final String word;
  final String gender;

  const _VocabPromptLine({
    required this.prompt,
    required this.article,
    required this.word,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final safeArticle = article.trim();
    final safeWord = word.trim().isNotEmpty ? word.trim() : prompt.trim();
    final hasArticle = safeArticle.isNotEmpty && word.trim().isNotEmpty;
    final showGender = gender.trim().isNotEmpty;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        Text.rich(
          TextSpan(
            children: hasArticle
                ? [
                    TextSpan(
                      text: "$safeArticle ",
                      style: const TextStyle(
                        color: Color(0xFF2AFADF),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: safeWord,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        height: 1.2,
                      ),
                    ),
                  ]
                : [
                    TextSpan(
                      text: safeWord,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        height: 1.2,
                      ),
                    ),
                  ],
          ),
        ),
        if (showGender)
          _GenderChip(value: gender.trim()),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String value;

  const _GenderChip({required this.value});

  @override
  Widget build(BuildContext context) {
    final trimmed = value.trim();
    final display = trimmed.isEmpty
        ? ""
        : (trimmed.length <= 2 && !trimmed.contains(' '))
            ? trimmed.toLowerCase()
            : trimmed.substring(0, 1).toLowerCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Text(
        display,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 11.5,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}



class _ChoiceSet {
  final List<String> choices;
  final int correctIndex;

  const _ChoiceSet({required this.choices, required this.correctIndex});
}

class _Leader {
  final String? userId;
  final String name;
  final int score;
  final bool isMe;
  final int correct;
  final int total;
  final bool isHost;
  final bool isMuted;
  final bool isSpeaking;
  final LeaderboardAnswer lastAnswer;
  final String? avatarUrl;

  const _Leader(
    this.name,
    this.score,
    this.isMe, {
    this.correct = 0,
    this.total = 0,
    this.isHost = false,
    this.isMuted = false,
    this.isSpeaking = false,
    this.lastAnswer = LeaderboardAnswer.none,
    this.userId,
    this.avatarUrl,
  });

  _Leader copyWith({
    int? score,
    int? correct,
    int? total,
    bool? isHost,
    bool? isMuted,
    bool? isSpeaking,
    LeaderboardAnswer? lastAnswer,
    String? userId,
    String? avatarUrl,
  }) {
    return _Leader(
      name,
      score ?? this.score,
      isMe,
      correct: correct ?? this.correct,
      total: total ?? this.total,
      isHost: isHost ?? this.isHost,
      isMuted: isMuted ?? this.isMuted,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      lastAnswer: lastAnswer ?? this.lastAnswer,
      userId: userId ?? this.userId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? color;

  const _Pill({
    required this.text,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color ?? Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconGlass extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconGlass({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.92)),
      ),
    );
  }
}
