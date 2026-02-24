import 'package:flutter/material.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/core/widgets/language_picker_sheet.dart';
import 'package:soma/core/widgets/neon_button.dart';
import 'package:soma/core/widgets/premium_dialog.dart';
import 'package:soma/core/widgets/responsive.dart';
import 'package:soma/core/widgets/selection_controls.dart';
import 'package:soma/data/circles_repository.dart';
import 'package:soma/data/languages.dart';
import 'package:soma/data/quiz_repository.dart';
import 'package:soma/data/settings_repository.dart';
import 'package:soma/data/soma_plus_repository.dart';
import 'package:soma/features/circles/circle_lobby_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

class CreateCircleScreen extends StatefulWidget {
  const CreateCircleScreen({super.key});

  @override
  State<CreateCircleScreen> createState() => _CreateCircleScreenState();
}

class _CreateCircleScreenState extends State<CreateCircleScreen> {
  // Basic setup
  String speakLang = 'en';
  String learnLang = 'es';
  String level = 'A';
  String mode = 'Vocabulary'; // Vocabulary | Sentences
  String circleName = '';

  // Room limits
  int maxPlayers = 5; // 1..5
  int questions = 15; // 5..50
  int timePerQ = 10; // 5..60 seconds

  // Advanced
  bool allowSpectators = true;
  bool enableVoice = true;
  bool enableChat = true;
  bool isPrivateCircle = false;
  bool _isLoading = false;
  SomaSubscriptionTier _tier = SomaSubscriptionTier.free;

  @override
  void initState() {
    super.initState();
    _loadTier();
  }

  Future<void> _loadTier() async {
    final settings = await settingsRepository.getSettings();
    if (!mounted) return;
    setState(() {
      _tier = SomaPlusRepository.parseTier(settings['plus_plan']?.toString());
    });
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String langName(final String code) {
      return kLanguages
          .firstWhere(
            (final l) => l.code == code,
            orElse: () => kLanguages.first,
          )
          .name;
    }

    final canCreate = circleName.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveFrame(
          child: LayoutBuilder(
            builder: (final context, final constraints) {
              final compactHeight = constraints.maxHeight < 760;
              final sectionSpacing = compactHeight ? 12.0 : 14.0;
              final rowSpacing = compactHeight ? 8.0 : 10.0;

              return Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                child: Column(
                  children: [
                    _TopBar(
                      title: l10n.circlesCreateCircle,
                      onBack: () => Navigator.pop(context),
                      onHelp: () async {
                        await showPremiumDialog(
                          context: context,
                          title: l10n.circlesCreateHelpTitle,
                          body: l10n.circlesCreateHelpBody,
                          confirmText: l10n.ok,
                        );
                      },
                    ),
                    SizedBox(height: sectionSpacing),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // Main form card
                          Glass(
                            radius: BorderRadius.circular(26),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionTitle(l10n.circlesCircleName),
                                const SizedBox(height: 10),
                                Container(
                                  height: 52,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.55),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.16)),
                                  ),
                                  child: TextField(
                                    onChanged: (final value) =>
                                        setState(() => circleName = value),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.w700),
                                    cursorColor:
                                        Theme.of(context).colorScheme.primary,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText: l10n.circlesEnterName,
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.5)),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(height: sectionSpacing),
                                _SectionTitle(l10n.circlesLanguages),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _SelectTile(
                                        label: l10n.iSpeak,
                                        value: langName(speakLang),
                                        icon: Icons.record_voice_over_rounded,
                                        onTap: () async {
                                          final v = await _pickFrom(
                                            context,
                                            title: l10n.chooseYourLanguage,
                                            items: kLanguages,
                                            current: kLanguages.firstWhere(
                                                (final l) =>
                                                    l.code == speakLang),
                                          );
                                          if (v != null) {
                                            setState(() => speakLang = v.code);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _SelectTile(
                                        label: l10n.iWantToLearn,
                                        value: langName(learnLang),
                                        icon: Icons.translate_rounded,
                                        onTap: () async {
                                          final v = await _pickFrom(
                                            context,
                                            title: l10n.chooseLearningLanguage,
                                            items: kLanguages,
                                            current: kLanguages.firstWhere(
                                                (final l) =>
                                                    l.code == learnLang),
                                          );
                                          if (v != null) {
                                            setState(() => learnLang = v.code);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sectionSpacing),
                                _SectionTitle(l10n.circlesModeTitle),
                                const SizedBox(height: 10),
                                _SegmentedNeon(
                                  leftLabel: l10n.soloModeVocabulary,
                                  leftValue: 'Vocabulary',
                                  rightLabel: l10n.soloModeSentences,
                                  rightValue: 'Sentences',
                                  value: mode,
                                  onChanged: (final v) =>
                                      setState(() => mode = v),
                                ),
                                SizedBox(height: sectionSpacing),
                                _SectionTitle(l10n.circlesLevelTitle),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _LevelChip(
                                        label: l10n.levelBeginner,
                                        selected: level == 'A',
                                        onTap: () =>
                                            setState(() => level = 'A'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _LevelChip(
                                        label: l10n.levelIntermediate,
                                        selected: level == 'B',
                                        onTap: () =>
                                            setState(() => level = 'B'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _LevelChip(
                                        label: l10n.levelAdvanced,
                                        selected: level == 'C',
                                        onTap: () =>
                                            setState(() => level = 'C'),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: compactHeight ? 14 : 16),
                                _SectionTitle(l10n.circlesRoomSetup),
                                SizedBox(height: rowSpacing),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _PresetChip(
                                      label: 'Beginner Fast 10Q',
                                      onTap: () => setState(() {
                                        level = 'A';
                                        mode = 'Vocabulary';
                                        questions = 10;
                                        timePerQ = 8;
                                        maxPlayers = 5;
                                      }),
                                    ),
                                    _PresetChip(
                                      label: 'Exam Prep 20Q',
                                      onTap: () => setState(() {
                                        level = 'B';
                                        mode = 'Sentences';
                                        questions = 20;
                                        timePerQ = 15;
                                        maxPlayers = 5;
                                      }),
                                    ),
                                  ],
                                ),
                                _StepperRow(
                                  title: l10n.circlesPlayers,
                                  subtitle: l10n.circlesPlayersRange,
                                  valueText: '$maxPlayers',
                                  onMinus: maxPlayers > 1
                                      ? () => setState(() => maxPlayers--)
                                      : null,
                                  onPlus: maxPlayers < 5
                                      ? () => setState(() => maxPlayers++)
                                      : null,
                                ),
                                SizedBox(height: rowSpacing),
                                _StepperRow(
                                  title: l10n.circlesQuestions,
                                  subtitle: l10n.circlesQuestionsSubtitle,
                                  valueText: '$questions',
                                  onMinus: questions > 5
                                      ? () => setState(() => questions -= 5)
                                      : null,
                                  onPlus: questions < 50
                                      ? () => setState(() => questions += 5)
                                      : null,
                                ),
                                const SizedBox(height: 10),
                                _StepperRow(
                                  title: l10n.circlesTimePerQuestion,
                                  subtitle: l10n.circlesSecondsPerQuestion,
                                  valueText: l10n.secondsShort(timePerQ),
                                  onMinus: timePerQ > 5
                                      ? () => setState(() => timePerQ -= 1)
                                      : null,
                                  onPlus: timePerQ < 60
                                      ? () => setState(() => timePerQ += 1)
                                      : null,
                                ),
                                SizedBox(height: compactHeight ? 14 : 16),
                                _SectionTitle(l10n.circlesAdvanced),
                                SizedBox(height: rowSpacing),
                                _ToggleRow(
                                  title: l10n.circlesAllowSpectators,
                                  subtitle: l10n.circlesAllowSpectatorsSubtitle,
                                  value: allowSpectators,
                                  onChanged: (final v) =>
                                      setState(() => allowSpectators = v),
                                ),
                                SizedBox(height: rowSpacing),
                                _ToggleRow(
                                  title: l10n.circlesLiveVoiceChat,
                                  subtitle: l10n.circlesLiveVoiceChatSubtitle,
                                  value: enableVoice,
                                  onChanged: (final v) =>
                                      setState(() => enableVoice = v),
                                ),
                                SizedBox(height: rowSpacing),
                                _ToggleRow(
                                  title: l10n.circlesLiveTextChat,
                                  subtitle: l10n.circlesLiveTextChatSubtitle,
                                  value: enableChat,
                                  onChanged: (final v) =>
                                      setState(() => enableChat = v),
                                ),
                                const SizedBox(height: 10),
                                _ToggleRow(
                                  title: 'Private Circle (Plus/Pro)',
                                  subtitle:
                                      'Only invited users can join this circle',
                                  value: isPrivateCircle,
                                  onChanged: (final v) async {
                                    if (v &&
                                        _tier == SomaSubscriptionTier.free) {
                                      await showPremiumDialog(
                                        context: context,
                                        title: 'Plus feature',
                                        body:
                                            'Private circles are available on Plus and Pro plans.',
                                        confirmText: l10n.ok,
                                      );
                                      return;
                                    }
                                    setState(() => isPrivateCircle = v);
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: sectionSpacing),

                          // Create button
                          NeonButton(
                            label: _isLoading
                                ? l10n.loading
                                : l10n.circlesCreateCircle,
                            onTap: _isLoading
                                ? () {}
                                : () async {
                                    if (!canCreate) {
                                      await showPremiumDialog(
                                        context: context,
                                        title: l10n.circlesCircleName,
                                        body: l10n.circlesEnterName,
                                        confirmText: l10n.ok,
                                      );
                                      return;
                                    }

                                    if (isPrivateCircle &&
                                        _tier == SomaSubscriptionTier.free) {
                                      await showPremiumDialog(
                                        context: context,
                                        title: 'Plus feature',
                                        body:
                                            'Upgrade to Plus or Pro to create private circles.',
                                        confirmText: l10n.ok,
                                      );
                                      return;
                                    }

                                    setState(() => _isLoading = true);

                                    try {
                                      // Fetch questions from Supabase-backed CSV tables
                                      final String courseId =
                                          '$speakLang-$learnLang';

                                      List<Map<String, dynamic>> quizQuestions =
                                          [];
                                      try {
                                        appLogger.debug(
                                            'Fetching questions for $courseId (Mode: $mode)...');
                                        if (mode == 'Vocabulary') {
                                          quizQuestions = await quizRepository
                                              .getVocabQuestionsFromSupabase(
                                                  courseId, questions);
                                        } else {
                                          quizQuestions = await quizRepository
                                              .getSentenceQuestionsFromSupabase(
                                                  courseId, questions);
                                        }

                                        if (quizQuestions.isEmpty) {
                                          throw Exception(
                                              'No questions found for $courseId. Please try another language pair.');
                                        }
                                        appLogger.debug(
                                            'Fetched ${quizQuestions.length} questions.');
                                      } catch (e) {
                                        appLogger.debug(
                                            'Error fetching questions: $e');
                                        rethrow; // Propagate to outer catch to show SnackBar
                                      }

                                      final circleId =
                                          await circlesRepository.createCircle(
                                        name: circleName.trim(),
                                        fromLang: speakLang,
                                        toLang: learnLang,
                                        mode: mode,
                                        level: level,
                                        maxPlayers: maxPlayers,
                                        questionsCount: questions,
                                        timePerQ: timePerQ,
                                        allowSpectators: allowSpectators,
                                        isLocked: isPrivateCircle,
                                        questions: quizQuestions,
                                      );

                                      if (!context.mounted) return;

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(l10n.circlesCreatedSuccess),
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );

                                      // Navigate to the Lobby with the new ID
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (final context) =>
                                              CircleLobbyScreen(
                                                  circleId: circleId),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(l10n.circlesCreateError(
                                              e.toString())),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  },
                          ),

                          SizedBox(height: compactHeight ? 10 : 12),

                          // Helper hint
                          Text(
                            l10n.circlesHostTip,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.72),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: compactHeight ? 16 : 20),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// ---------- UI Parts ----------

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onHelp;

  const _TopBar({
    required this.title,
    required this.onBack,
    required this.onHelp,
  });

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        _IconGlassButton(icon: Icons.arrow_back_rounded, onTap: onBack),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        _IconGlassButton(icon: Icons.help_outline_rounded, onTap: onHelp),
      ],
    );
  }
}

class _IconGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconGlassButton({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) {
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
            child: Icon(icon,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.92),
                size: 22),
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
  Widget build(final BuildContext context) {
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

class _SelectTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _SelectTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
          border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.9)),
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
                          .withValues(alpha: 0.62),
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
                    .withValues(alpha: 0.62)),
          ],
        ),
      ),
    );
  }
}

class _SegmentedNeon extends StatelessWidget {
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;
  final String value;
  final ValueChanged<String> onChanged;

  const _SegmentedNeon({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(final BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: _SegButton(
              label: leftLabel,
              selected: value == leftValue,
              onTap: () => onChanged(leftValue),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SegButton(
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

class _SegButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return AppSelectablePill(
      label: label,
      selected: selected,
      onTap: onTap,
      fontSize: 13.5,
      height: 44,
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
  Widget build(final BuildContext context) {
    return AppSelectablePill(
      label: label,
      selected: selected,
      onTap: onTap,
      fontSize: 13,
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}

class _StepperRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String valueText;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const _StepperRow({
    required this.title,
    required this.subtitle,
    required this.valueText,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.62),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _MiniBtn(icon: Icons.remove_rounded, onTap: onMinus),
          const SizedBox(width: 10),
          SizedBox(
            width: 62,
            child: Text(
              valueText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _MiniBtn(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}

class _MiniBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _MiniBtn({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: disabled ? 0.04 : 0.08),
          border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: disabled ? 0.08 : 0.14)),
        ),
        child: Center(
          child: Icon(icon,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: disabled ? 0.35 : 0.90)),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.62),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          AppNeonSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// ---------- Picker helper ----------

Future<LangOption?> _pickFrom(
  final BuildContext context, {
  required final String title,
  required final List<LangOption> items,
  required final LangOption current,
}) async {
  return showModalBottomSheet<LangOption>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (final ctx) => LanguagePickerSheet(
      title: title,
      searchHint: 'Search language',
      noMatchesText: 'No matches',
      items: items,
      current: current,
      darkModeStyle: Theme.of(ctx).brightness == Brightness.dark,
    ),
  );
}

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PresetChip({required this.label, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
          border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.14)),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
