import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/theme/motion.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/widgets/soma_background.dart';
import '../../core/widgets/responsive.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/staggered_in.dart';
import '../../core/widgets/reward_sparkle.dart';
import '../common/results_screen.dart';
import '../../models/leaderboard_player.dart';
import '../../data/circles_repository.dart';
import '../../data/circle_voice_service.dart';
import '../../data/auth_repository.dart';
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
  static const double _leaderRowHeight = 56;
  static const double _leaderRowSpacing = 8;

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
  
  @override
  void initState() {
    super.initState();
    _joinRequested = widget.joinRequested;
    _listenParticipants();
    _connectVoice();
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
            choices: (q['choices'] as List?)?.map((e) => e.toString()).toList() ?? const ['...', '...', '...', '...'],
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
        // Fallback to placeholder on error
        questions = [
          _Question(
            prompt: 'Error loading questions',
            choices: const ["...", "...", "...", "..."],
            correctIndex: 0,
            translation: '',
            reading: '',
            fullSentence: '',
            article: '',
            word: '',
            gender: '',
          )
        ];
      }
    } else {
      debugPrint('No questions received - using placeholder');
      questions = [
        _Question(
          prompt: _waitingForHostText,
          choices: const ["...", "...", "...", "..."],
          correctIndex: 0,
          translation: '',
          reading: '',
          fullSentence: '',
          article: '',
          word: '',
          gender: '',
        )
      ];
    }

    _prepareQuestion();
    _startTimer();
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
          profile?['display_name'] ?? profile?['username'] ?? '...',
          score,
          isMe,
          correct: 0, // We could track correct answers in DB too, but score is enough for leaderboard
          total: 0,
          isHost: role == 'host',
          isMuted: _isMutedFor(uid ?? ''),
          isSpeaking: _isSpeakingFor(uid ?? ''),
          userId: uid,
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
  bool showReading = true;
  List<String> _choices = [];
  int _correctIndex = 0;
  double _speechRate = 1.0;
  Timer? _ttsTimer;
  final Map<String, int> _answersByUser = {};
  final Map<String, int> _answerTimeByUser = {};
  final List<Timer> _answerTimers = [];
  final Random _random = Random();

  // Timer per question
  late int t;
  Timer? timer;

  // Score demo
  int myScore = 0;

  // Leaderboard demo
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
    HapticFeedback.selectionClick();
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
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
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
    _prepareQuestion();
    _startTimer();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final q = questions[qIndex];
    final progress = (qIndex + 1) / questions.length;
    final hasTranslation = q.translation.trim().isNotEmpty;
    final showReadingLine = showReading && q.reading.trim().isNotEmpty && (!hasTranslation || revealed);
    final sortedLeaders = List<_Leader>.from(leaders)
      ..sort((a, b) => b.score.compareTo(a.score));
    final meKey = _currentUserKey;
    final isLocked = meKey != null && _answersByUser.containsKey(meKey);
    final canParticipate = canPlay && !isLocked;

    return Scaffold(
      body: SomaBackground(
        child: SafeArea(
            child: ResponsiveFrame(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  children: [
                  // Top bar (timer + role/score + exit)
                  Row(
                    children: [
                      _TinyGlass(
                        child: Row(
                          children: [
                            const Icon(Icons.timer_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "0:${t.toString().padLeft(2, "0")}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TinyGlass(
                          child: canPlay
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      "$myScore",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                )
                               : _RolePill(
                                   icon: isHost ? Icons.admin_panel_settings_rounded : Icons.visibility_rounded,
                                   label: isHost ? l10n.roleHost : l10n.roleSpectator,
                                 ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _TinyGlass(
                        onTap: () => setState(() => showReading = !showReading),
                        child: Icon(
                          showReading ? Icons.text_fields_rounded : Icons.text_fields_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _TinyGlass(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close_rounded, color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Progress bar
                  _QuizProgressBar(progress: progress),

                  if (isSpectator) ...[
                    const SizedBox(height: 12),
                      _RoleCallout(
                        icon: Icons.visibility_rounded,
                        title: l10n.liveQuizSpectatorModeTitle,
                        subtitle: l10n.liveQuizSpectatorModeSubtitle,
                      ),
                  ] else ...[
                    const SizedBox(height: 12),
                  ],

                  // Question card
                  Glass(
                    radius: BorderRadius.circular(26),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.liveQuizQuestionCounter(qIndex + 1, questions.length),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.70),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_isSentenceQuestion(q))
                          Text(
                            q.prompt,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              height: 1.2,
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
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        if (hasTranslation) ...[
                          const SizedBox(height: 8),
                          Text(
                            q.translation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ],
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
                  const SizedBox(height: 12),

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

                        return StaggeredIn(
                          index: i,
                          child: _AnswerTile(
                            text: _choices[i],
                            isSelected: isSelected,
                            disabled: !canPlay || isLocked,
                            state: !showCorrect
                                ? _AnswerState.normal
                                : (isCorrect
                                    ? _AnswerState.correct
                                    : (isSelected ? _AnswerState.wrong : _AnswerState.normal)),
                            onTap: canPlay ? () => _select(i) : null,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // CTA
                  if (isSpectator) ...[
                    NeonButton(
                      label: _joinRequested ? l10n.liveQuizRequestSent : l10n.liveQuizRequestToJoin,
                      onTap: canRequestJoin ? _requestJoin : null,
                    ),
                    const SizedBox(height: 10),
                    _SpectatorFooter(),
                  ],

                  const SizedBox(height: 12),

                  // Mini leaderboard
                  Glass(
                    radius: BorderRadius.circular(22),
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: SizedBox(
                      height: sortedLeaders.isEmpty
                          ? 0
                          : (sortedLeaders.length * (_leaderRowHeight + _leaderRowSpacing)) -
                              _leaderRowSpacing,
                      child: Stack(
                        children: sortedLeaders.asMap().entries.map((entry) {
                          final i = entry.key;
                          final l = entry.value;
                          return AnimatedPositioned(
                            key: ValueKey(_leaderKey(l)),
                            duration: MotionTokens.medium,
                            curve: MotionTokens.movementCurve,
                            left: 0,
                            right: 0,
                            top: i * (_leaderRowHeight + _leaderRowSpacing),
                            child: StaggeredIn(
                              index: i,
                              child: SizedBox(
                                height: _leaderRowHeight,
                                child: _LiveLeaderboardRow(
                                  rank: i + 1,
                                  leader: l,
                                  onToggleMute: l.isMe ? () => _toggleMuteFor(l.name) : null,
                                  onAvatarTap: l.userId != null ? () => _openProfileSheet(l.userId) : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
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

class _LiveLeaderboardRow extends StatelessWidget {
  final int rank;
  final _Leader leader;
  final VoidCallback? onToggleMute;
  final VoidCallback? onAvatarTap;

  const _LiveLeaderboardRow({
    required this.rank,
    required this.leader,
    this.onToggleMute,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final baseColor = leader.isMe ? Colors.white.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.08);
    final borderColor = leader.isMe ? Colors.white.withValues(alpha: 0.24) : Colors.white.withValues(alpha: 0.12);
    final pulse = leader.lastAnswer == LeaderboardAnswer.correct;

    return AnimatedScale(
      scale: pulse ? 1.02 : 1,
      duration: MotionTokens.short,
      curve: MotionTokens.standardCurve,
      child: AnimatedContainer(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: baseColor,
        border: Border.all(color: borderColor),
        boxShadow: pulse
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
          _RankChip(rank: rank),
          const SizedBox(width: 10),
          PressableScale(
            onTap: onAvatarTap,
            child: _AvatarBubble(
              name: leader.name,
              heroTag: leader.userId == null ? null : "profile-avatar-${leader.userId}",
            ),
          ),
          const SizedBox(width: 10),
          if (onToggleMute != null)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onToggleMute,
              child: _VoiceBadge(muted: leader.isMuted, speaking: leader.isSpeaking),
            )
          else
            _VoiceBadge(muted: leader.isMuted, speaking: leader.isSpeaking),
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
                        leader.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                    if (leader.isHost) ...[
                      const SizedBox(width: 6),
                      _Tag(label: l10n.tagHost),
                    ],
                    if (leader.isMe) ...[
                      const SizedBox(width: 6),
                      _Tag(label: l10n.tagYou),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _AnswerIndicator(result: leader.lastAnswer),
                    const SizedBox(width: 6),
                    Text(
                      leader.lastAnswer == LeaderboardAnswer.correct
                          ? l10n.statusCorrect
                          : leader.lastAnswer == LeaderboardAnswer.wrong
                              ? l10n.statusWrong
                              : l10n.statusWaiting,
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
                "${leader.score}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.pointsAbbrev,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w700,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

class _RankChip extends StatelessWidget {
  final int rank;

  const _RankChip({required this.rank});

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

class _AvatarBubble extends StatelessWidget {
  final String name;
  final String? heroTag;

  const _AvatarBubble({required this.name, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isNotEmpty ? trimmed.substring(0, 1).toUpperCase() : "?";
    final avatar = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF2AFADF), Color(0xFF7C7CFF), Color(0xFFFF4ECD)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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

    if (heroTag == null) {
      return avatar;
    }

    return Hero(tag: heroTag!, child: avatar);
  }
}

class _VoiceBadge extends StatelessWidget {
  final bool muted;
  final bool speaking;

  const _VoiceBadge({required this.muted, required this.speaking});

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

class _AnswerIndicator extends StatelessWidget {
  final LeaderboardAnswer result;

  const _AnswerIndicator({required this.result});

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

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

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

class _RoleCallout extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _RoleCallout({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withValues(alpha: 0.10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 20),
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
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.68),
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

class _SpectatorFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Glass(
      radius: BorderRadius.circular(22),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Icon(Icons.visibility_rounded, color: Colors.white.withValues(alpha: 0.9), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.liveQuizSpectatorFooter,
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF2AFADF), Color(0xFF7C7CFF), Color(0xFFFF4FD8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C7CFF).withValues(alpha: 0.55),
                    blurRadius: 12,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _AnswerState { normal, correct, wrong }

class _AnswerTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool disabled;
  final _AnswerState state;
  final VoidCallback? onTap;

  const _AnswerTile({
    required this.text,
    required this.isSelected,
    this.disabled = false,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = Colors.white.withValues(alpha: 0.14);

    Color bg = Colors.black.withValues(alpha: 0.14);
    Color border = baseBorder;

    if (isSelected) {
      border = Colors.white.withValues(alpha: 0.30);
      bg = Colors.black.withValues(alpha: 0.18);
    }
    if (state == _AnswerState.correct) {
      border = const Color(0xFF2AFADF).withValues(alpha: 0.85);
      bg = const Color(0xFF2AFADF).withValues(alpha: 0.14);
    } else if (state == _AnswerState.wrong) {
      border = const Color(0xFFFF4FD8).withValues(alpha: 0.85);
      bg = const Color(0xFFFF4FD8).withValues(alpha: 0.12);
    }

    final textColor = disabled ? Colors.white.withValues(alpha: 0.65) : Colors.white;
    return PressableScale(
      onTap: onTap,
      child: AnimatedScale(
        scale: state == _AnswerState.correct ? 1.02 : 1,
        duration: MotionTokens.short,
        curve: MotionTokens.standardCurve,
        child: AnimatedContainer(
          duration: MotionTokens.short,
          curve: MotionTokens.standardCurve,
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: bg,
            border: Border.all(color: border),
            boxShadow: state == _AnswerState.correct
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
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              if (state == _AnswerState.correct) ...[
                const Icon(Icons.check_rounded, color: Color(0xFF2AFADF)),
                const SizedBox(width: 6),
                const RewardSparkle(show: true),
              ] else if (state == _AnswerState.wrong)
                const Icon(Icons.close_rounded, color: Color(0xFFFF4FD8))
              else
                Icon(Icons.circle_outlined, color: Colors.white.withValues(alpha: 0.22)),
            ],
          ),
        ),
      ),
    );
  }
}

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
        radius: BorderRadius.circular(18),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            ...rates.map((rate) {
              final selected = rate == selectedRate;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _SpeedChip(
                  label: "${rate.toStringAsFixed(rate == 1.0 ? 0 : 2)}x",
                  selected: selected,
                  onTap: disabled ? null : () => onRateSelected(rate),
                ),
              );
            }),
            const Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: disabled ? null : onSpeak,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.volume_up_rounded, color: Colors.white.withValues(alpha: 0.9)),
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
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? Colors.white.withValues(alpha: 0.16) : Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: selected ? Colors.white.withValues(alpha: 0.32) : Colors.white.withValues(alpha: 0.16)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
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
    );
  }
}
