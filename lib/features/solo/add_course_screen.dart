import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/theme/tokens.dart';
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
            child: Padding(
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

                  const SizedBox(height: 18),

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
                        const SizedBox(height: 16),
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
                          const SizedBox(height: 12),
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

                  const SizedBox(height: 10),
                ],
              ),
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
  final l10n = AppLocalizations.of(context);
  final scheme = Theme.of(context).colorScheme;
  
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
                      e.name.toLowerCase().contains(normalized) ||
                      e.code.toLowerCase().contains(normalized))
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
                            style: TextStyle(
                              color: scheme.onSurface,
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
                                Future.delayed(Duration.zero,
                                    () => searchFocus.requestFocus());
                              }
                            },
                            icon: Icon(
                              showSearch
                                  ? Icons.search_off_rounded
                                  : Icons.search_rounded,
                              color: scheme.onSurface.withValues(alpha: 0.85),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: Icon(Icons.close_rounded,
                                color: scheme.onSurface.withValues(alpha: 0.85)),
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
                            color: Theme.of(context).brightness == Brightness.light
                                ? scheme.onSurface.withValues(alpha: 0.08)
                                : T.fieldFill,
                            border: Border.all(
                                color: scheme.onSurface.withValues(alpha: 0.2)),
                          ),
                          child: TextField(
                            focusNode: searchFocus,
                            onChanged: (v) => setModalState(() => query = v),
                            style: TextStyle(
                                color: scheme.onSurface,
                                fontWeight: FontWeight.w700),
                            cursorColor: scheme.primary,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: l10n.searchLanguage,
                              hintStyle: TextStyle(
                                  color: scheme.onSurface.withValues(alpha: 0.5)),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search_rounded,
                                  color: scheme.onSurface.withValues(alpha: 0.7)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            l10n.noMatches,
                            style: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.7),
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
                                    ? scheme.primary.withValues(alpha: 0.15)
                                    : scheme.onSurface.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: selected
                                      ? scheme.primary.withValues(alpha: 0.5)
                                      : scheme.onSurface.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      e.name,
                                      style: TextStyle(
                                        color: scheme.onSurface,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  if (selected)
                                    Icon(Icons.check_rounded,
                                        color: scheme.primary),
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
