import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/widgets/selection_controls.dart';
import '../../core/widgets/premium_dialog.dart';
import 'circle_lobby_screen.dart';
import '../../core/theme/tokens.dart';
import '../../data/circles_repository.dart';
import '../../core/widgets/responsive.dart';

import '../../data/languages.dart';
import '../../data/quiz_repository.dart';

class CreateCircleScreen extends StatefulWidget {
  const CreateCircleScreen({super.key});

  @override
  State<CreateCircleScreen> createState() => _CreateCircleScreenState();
}

class _CreateCircleScreenState extends State<CreateCircleScreen> {
  // Basic setup
  String speakLang = "en";
  String learnLang = "es";
  String level = "A";
  String mode = "Vocabulary"; // Vocabulary | Sentences
  String circleName = "";

  // Room limits
  int maxPlayers = 5; // 1..5
  int questions = 15; // 5..50
  int timePerQ = 10; // 5..60 seconds

  // Advanced
  bool allowSpectators = true;
  bool enableVoice = true;
  bool enableChat = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String langName(String code) {
      return kLanguages.firstWhere(
        (l) => l.code == code,
        orElse: () => kLanguages.first,
      ).name;
    }

    final canCreate = circleName.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
          child: ResponsiveFrame(
            child: Padding(
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

                  const SizedBox(height: 14),

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
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: T.fieldFill,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                                ),
                                child: TextField(
                                  onChanged: (value) => setState(() => circleName = value),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                  cursorColor: Colors.white,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText: l10n.circlesEnterName,
                                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

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
                                          current: kLanguages.firstWhere((l) => l.code == speakLang),
                                        );
                                        if (v != null) setState(() => speakLang = v.code);
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
                                          current: kLanguages.firstWhere((l) => l.code == learnLang),
                                        );
                                        if (v != null) setState(() => learnLang = v.code);
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              _SectionTitle(l10n.circlesModeTitle),
                              const SizedBox(height: 10),
                              _SegmentedNeon(
                                leftLabel: l10n.soloModeVocabulary,
                                leftValue: "Vocabulary",
                                rightLabel: l10n.soloModeSentences,
                                rightValue: "Sentences",
                                value: mode,
                                onChanged: (v) => setState(() => mode = v),
                              ),

                              const SizedBox(height: 14),

                              _SectionTitle(l10n.circlesLevelTitle),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _LevelChip(
                                      label: l10n.levelBeginner,
                                      selected: level == "A",
                                      onTap: () => setState(() => level = "A"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _LevelChip(
                                      label: l10n.levelIntermediate,
                                      selected: level == "B",
                                      onTap: () => setState(() => level = "B"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _LevelChip(
                                      label: l10n.levelAdvanced,
                                      selected: level == "C",
                                      onTap: () => setState(() => level = "C"),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              _SectionTitle(l10n.circlesRoomSetup),
                              const SizedBox(height: 10),

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
                                valueText: "$maxPlayers",
                                onMinus: maxPlayers > 1 ? () => setState(() => maxPlayers--) : null,
                                onPlus: maxPlayers < 5 ? () => setState(() => maxPlayers++) : null,
                              ),
                              const SizedBox(height: 10),

                              _StepperRow(
                                title: l10n.circlesQuestions,
                                subtitle: l10n.circlesQuestionsSubtitle,
                                valueText: "$questions",
                                onMinus: questions > 5 ? () => setState(() => questions -= 5) : null,
                                onPlus: questions < 50 ? () => setState(() => questions += 5) : null,
                              ),
                              const SizedBox(height: 10),

                              _StepperRow(
                                title: l10n.circlesTimePerQuestion,
                                subtitle: l10n.circlesSecondsPerQuestion,
                                valueText: l10n.secondsShort(timePerQ),
                                onMinus: timePerQ > 5 ? () => setState(() => timePerQ -= 1) : null,
                                onPlus: timePerQ < 60 ? () => setState(() => timePerQ += 1) : null,
                              ),

                              const SizedBox(height: 16),

                              _SectionTitle(l10n.circlesAdvanced),
                              const SizedBox(height: 10),

                              _ToggleRow(
                                title: l10n.circlesAllowSpectators,
                                subtitle: l10n.circlesAllowSpectatorsSubtitle,
                                value: allowSpectators,
                                onChanged: (v) => setState(() => allowSpectators = v),
                              ),
                              const SizedBox(height: 10),

                              _ToggleRow(
                                title: l10n.circlesLiveVoiceChat,
                                subtitle: l10n.circlesLiveVoiceChatSubtitle,
                                value: enableVoice,
                                onChanged: (v) => setState(() => enableVoice = v),
                              ),
                              const SizedBox(height: 10),

                              _ToggleRow(
                                title: l10n.circlesLiveTextChat,
                                subtitle: l10n.circlesLiveTextChatSubtitle,
                                value: enableChat,
                                onChanged: (v) => setState(() => enableChat = v),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Create button
                        NeonButton(
                          label: _isLoading ? l10n.loading : l10n.circlesCreateCircle,
                          onTap: _isLoading ? () {} : () async {
                            if (!canCreate) {
                              await showPremiumDialog(
                                context: context,
                                title: l10n.circlesCircleName,
                                body: l10n.circlesEnterName,
                                confirmText: l10n.ok,
                              );
                              return;
                            }
                            
                            setState(() => _isLoading = true);
                            
                            try {
                              // Fetch questions from Supabase-backed CSV tables
                              String courseId = "$speakLang-$learnLang"; 
                              
                              List<Map<String, dynamic>> quizQuestions = [];
                              try {
                                debugPrint("Fetching questions for $courseId (Mode: $mode)...");
                                if (mode == "Vocabulary") {
                                  quizQuestions = await quizRepository.getVocabQuestionsFromSupabase(courseId, questions);
                                } else {
                                  quizQuestions = await quizRepository.getSentenceQuestionsFromSupabase(courseId, questions);
                                }
                                
                                if (quizQuestions.isEmpty) {
                                  throw Exception("No questions found for $courseId. Please try another language pair.");
                                }
                                debugPrint("Fetched ${quizQuestions.length} questions.");
                              } catch (e) {
                                debugPrint("Error fetching questions: $e");
                                rethrow; // Propagate to outer catch to show SnackBar
                              }
                              
                              final circleId = await circlesRepository.createCircle(
                                name: circleName.trim(),
                                fromLang: speakLang,
                                toLang: learnLang,
                                mode: mode,
                                level: level,
                                maxPlayers: maxPlayers,
                                questionsCount: questions, 
                                timePerQ: timePerQ,
                                allowSpectators: allowSpectators,
                                questions: quizQuestions,
                              );

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.circlesCreatedSuccess),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 1),
                                ),
                              );

                              // Navigate to the Lobby with the new ID
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CircleLobbyScreen(circleId: circleId),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.circlesCreateError(e.toString())),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        // Helper hint
                        Text(
                          l10n.circlesHostTip,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.70),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
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
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconGlassButton(icon: Icons.arrow_back_rounded, onTap: onBack),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
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
            child: Icon(icon, color: Colors.white.withValues(alpha: 0.92), size: 22),
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
        color: Colors.white.withValues(alpha: 0.92),
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
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.black.withValues(alpha: 0.14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.9)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.expand_more_rounded, color: Colors.white.withValues(alpha: 0.65)),
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
  Widget build(BuildContext context) {
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
  Widget build(BuildContext context) {
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
  Widget build(BuildContext context) {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withValues(alpha: 0.14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
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
              style: const TextStyle(
                color: Colors.white,
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
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black.withValues(alpha: disabled ? 0.06 : 0.14),
          border: Border.all(color: Colors.white.withValues(alpha: disabled ? 0.08 : 0.14)),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white.withValues(alpha: disabled ? 0.35 : 0.90)),
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withValues(alpha: 0.14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
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
  BuildContext context, {
  required String title,
  required List<LangOption> items,
  required LangOption current,
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
              ? items
              : items
                  .where((e) =>
                      e.name.toLowerCase().contains(normalized) || e.code.toLowerCase().contains(normalized))
                  .toList();

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
                                Future.delayed(Duration.zero, () => searchFocus.requestFocus());
                              }
                            },
                            icon: Icon(
                              showSearch ? Icons.search_off_rounded : Icons.search_rounded,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.85)),
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
                            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                          ),
                          child: TextField(
                            focusNode: searchFocus,
                            onChanged: (v) => setModalState(() => query = v),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: "Search language",
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.7)),
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
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w700),
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
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: selected ? Colors.white.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.10),
                                border: Border.all(
                                  color: selected ? Colors.white.withValues(alpha: 0.26) : Colors.white.withValues(alpha: 0.10),
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
                                    Icon(Icons.check_rounded, color: Colors.white.withValues(alpha: 0.9)),
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


class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PresetChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
