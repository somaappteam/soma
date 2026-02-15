import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/language_picker_sheet.dart';
import '../../models/solo_course.dart';
import '../../core/widgets/responsive.dart';

import '../../data/languages.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  late LangOption speak;
  late LangOption learn;

  @override
  void initState() {
    super.initState();
    speak = kLanguages.firstWhere((l) => l.code == "en");
    learn = kLanguages.firstWhere((l) => l.code == "es");
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final valid = speak.code != learn.code;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
          child: ResponsiveFrame(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compactHeight = constraints.maxHeight < 760;
                final sectionSpacing = compactHeight ? 14.0 : 18.0;
                final bottomSpacing = compactHeight ? 8.0 : 10.0;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                  child: Column(
                    children: [
                  Row(
                    children: [
                      Glass(
                        radius: BorderRadius.circular(14),
                        padding: EdgeInsets.zero,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => Navigator.pop(context),
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(
                              child: Icon(Icons.arrow_back_ios_new_rounded,
                                  color: scheme.onSurface.withValues(alpha: 0.9),
                                  size: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.addCourse,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),

                  SizedBox(height: sectionSpacing),

                  Glass(
                    radius: BorderRadius.circular(24),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SelectTile(
                          label: l10n.iSpeak,
                          value: speak.name,
                          icon: Icons.record_voice_over_rounded,
                          onTap: () async {
                            final v = await _pickLanguage(
                              context,
                              title: l10n.chooseYourLanguage,
                              items: kLanguages,
                              current: speak,
                            );
                            if (v != null) setState(() => speak = v);
                          },
                        ),
                        SizedBox(height: compactHeight ? 12 : 16),
                        _SelectTile(
                          label: l10n.iWantToLearn,
                          value: learn.name,
                          icon: Icons.translate_rounded,
                          onTap: () async {
                            final v = await _pickLanguage(
                              context,
                              title: l10n.chooseLearningLanguage,
                              items: kLanguages,
                              current: learn,
                            );
                            if (v != null) setState(() => learn = v);
                          },
                        ),
                        if (!valid) ...[
                          SizedBox(height: compactHeight ? 10 : 12),
                          Text(
                            l10n.chooseTwoDifferentLanguages,
                            style: TextStyle(
                                color: scheme.error,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Create button
                  Glass(
                    radius: BorderRadius.circular(26),
                    padding: EdgeInsets.zero,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(26),
                      onTap: valid
                          ? () {
                              final id = "solo_${speak.code}_${learn.code}";
                              final course = SoloCourse(
                                id: id,
                                title: l10n.soloCourseTitle,
                                subtitle: "${speak.name} → ${learn.name}",
                                iconUrl: "",
                              );
                              Navigator.pop(context, course);
                            }
                          : null,
                      child: SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            l10n.createCourse,
                            style: TextStyle(
                              color: scheme.primary.withValues(alpha: valid ? 1 : 0.45),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: bottomSpacing),
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
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: scheme.onSurface.withValues(alpha: 0.1),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: scheme.onSurface.withValues(alpha: 0.9)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.expand_more_rounded,
                color: scheme.onSurface.withValues(alpha: 0.65)),
          ],
        ),
      ),
    );
  }
}

Future<LangOption?> _pickLanguage(
  BuildContext context, {
  required String title,
  required List<LangOption> items,
  required LangOption current,
}) async {
  return showModalBottomSheet<LangOption>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => LanguagePickerSheet(
      title: title,
      searchHint: l10n.searchLanguage,
      noMatchesText: l10n.noMatches,
      items: items,
      current: current,
    ),
  );
}
