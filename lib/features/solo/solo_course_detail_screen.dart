import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../models/solo_course.dart';
import 'solo_setup_screen.dart';

enum SoloMode { vocabulary, sentences, review }

class SoloCourseDetailScreen extends StatelessWidget {
  const SoloCourseDetailScreen({super.key, required this.course});
  final SoloCourse course;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compactHeight = constraints.maxHeight < 760;
            final sectionSpacing = compactHeight ? 10.0 : 12.0;
            final reviewTopSpacing = compactHeight ? 18.0 : 24.0;
            final topSpacing = compactHeight ? 12.0 : 18.0;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _IconGlass(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              course.subtitle,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: scheme.onSurface, fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: topSpacing),

                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _ModeCard(
                              icon: Icons.fact_check_rounded,
                              title: l10n.soloModeVocabulary,
                              subtitle: l10n.soloModeVocabularySubtitle,
                              onTap: () => _go(context, SoloMode.vocabulary),
                            ),
                            SizedBox(height: sectionSpacing),
                            _ModeCard(
                              icon: Icons.edit_note_rounded,
                              title: l10n.soloModeSentences,
                              subtitle: l10n.soloModeSentencesSubtitle,
                              onTap: () => _go(context, SoloMode.sentences),
                            ),
                            SizedBox(height: reviewTopSpacing),
                            Glass(
                              radius: BorderRadius.circular(22),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.soloModeReview,
                                      style: TextStyle(color: scheme.onSurface, fontSize: 16, fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.soloModeReviewDescription,
                                    style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.65), fontSize: 12.5, fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: compactHeight ? 10 : 12),
                                  NeonButton(
                                    label: l10n.startReview,
                                    onTap: () => _go(context, SoloMode.review),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _go(BuildContext context, SoloMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SoloSetupScreen(course: course, mode: mode)),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ModeCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PressableScale(
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(22),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: scheme.onSurface.withValues(alpha: 0.1),
                border: Border.all(color: scheme.onSurface.withValues(alpha: 0.15)),
              ),
              child: Icon(icon, color: scheme.onSurface),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: scheme.onSurface, fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.65), fontSize: 12.5, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.55)),
          ],
        ),
      ),
    );
  }
}

class _IconGlass extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlass({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PressableScale(
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.92)),
      ),
    );
  }
}
