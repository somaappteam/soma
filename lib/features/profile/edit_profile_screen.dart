import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../data/profile_repository.dart';
import '../../models/user_profile.dart';
import '../../core/widgets/responsive.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile? initialProfile; // optional in case we create fresh
  const EditProfileScreen({super.key, this.initialProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late UserProfile draft;

  late final TextEditingController displayNameCtrl;
  late final TextEditingController usernameCtrl;
  late final TextEditingController bioCtrl;
  late final TextEditingController locationCtrl;

  int goalMinutes = 10;

  @override
  void initState() {
    super.initState();
    if (widget.initialProfile != null) {
      draft = widget.initialProfile!.copy();
    } else {
      draft = UserProfile(displayName: "", username: "", bio: "", location: "", dailyGoalMinutes: 10);
    }

    displayNameCtrl = TextEditingController(text: draft.displayName);
    usernameCtrl = TextEditingController(text: draft.username);
    bioCtrl = TextEditingController(text: draft.bio);
    locationCtrl = TextEditingController(text: draft.location);
    goalMinutes = draft.dailyGoalMinutes;
  }

  @override
  void dispose() {
    displayNameCtrl.dispose();
    usernameCtrl.dispose();
    bioCtrl.dispose();
    locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context);

    final next = UserProfile(
      displayName: displayNameCtrl.text.trim(),
      username: usernameCtrl.text.trim(),
      bio: bioCtrl.text.trim(),
      location: locationCtrl.text.trim(),
      dailyGoalMinutes: goalMinutes,
    );

    try {
      await profileRepository.updateProfile(next);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(l10n.editProfileUpdated)),
        );
        Navigator.pop(context);
      }
    } catch(e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(l10n.errorWithDetails(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
          child: ResponsiveFrame(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      _SmallIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.editProfileTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const Spacer(),
                      _SmallIconButton(
                        icon: Icons.check_rounded,
                        onTap: _save,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // Avatar card
                          Glass(
                            radius: BorderRadius.circular(24),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Row(
                              children: [
                                _Avatar(),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.editProfilePhotoLabel,
                                        style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.92),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                  ),      ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.editProfilePhotoSubtitle,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.5,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _ChipButton(
                                  label: l10n.editProfileChangePhoto,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(l10n.editProfileAvatarUploadSoon)),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Fields card
                          Glass(
                            radius: BorderRadius.circular(24),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _FieldLabel(l10n.editProfileDisplayNameLabel),
                                _GlassTextField(
                                  controller: displayNameCtrl,
                                  hint: l10n.editProfileDisplayNameHint,
                                  validator: (v) {
                                    final s = (v ?? "").trim();
                                    if (s.isEmpty) return l10n.editProfileDisplayNameRequired;
                                    if (s.length < 2) return l10n.editProfileDisplayNameTooShort;
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),

                                _FieldLabel(l10n.editProfileUsernameLabel),
                                _GlassTextField(
                                  controller: usernameCtrl,
                                  hint: l10n.editProfileUsernameHint,
                                  validator: (v) {
                                    final s = (v ?? "").trim();
                                    if (s.isEmpty) return l10n.editProfileUsernameRequired;
                                    if (s.length < 3) return l10n.editProfileUsernameTooShort;
                                    final ok = RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(s);
                                    if (!ok) return l10n.editProfileUsernameInvalid;
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),

                                _FieldLabel(l10n.editProfileBioLabel),
                                _GlassTextField(
                                  controller: bioCtrl,
                                  hint: l10n.editProfileBioHint,
                                  maxLines: 3,
                                  validator: (v) {
                                    final s = (v ?? "").trim();
                                    if (s.length > 120) return l10n.editProfileBioTooLong;
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),

                                _FieldLabel(l10n.editProfileLocationLabel),
                                _GlassTextField(
                                  controller: locationCtrl,
                                  hint: l10n.editProfileLocationHint,
                                  validator: (v) => null,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Daily goal
                          Glass(
                            radius: BorderRadius.circular(24),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.editProfileDailyGoalTitle,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.editProfileDailyGoalSubtitle,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.62),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    _GoalChip(min: 5, selected: goalMinutes == 5, onTap: () => setState(() => goalMinutes = 5)),
                                    _GoalChip(min: 10, selected: goalMinutes == 10, onTap: () => setState(() => goalMinutes = 10)),
                                    _GoalChip(min: 15, selected: goalMinutes == 15, onTap: () => setState(() => goalMinutes = 15)),
                                    _GoalChip(min: 20, selected: goalMinutes == 20, onTap: () => setState(() => goalMinutes = 20)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Save button
                          Glass(
                            radius: BorderRadius.circular(26),
                            padding: EdgeInsets.zero,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(26),
                              onTap: _save,
                              child: SizedBox(
                                height: 56,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    l10n.save,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900),
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
                ],
              ),
            ),
          ),
        ),
    );
  }
}

// ---------------- UI helpers ----------------

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(14),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Icon(icon,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.9),
                size: 22),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text("🙂",
            style: TextStyle(
                fontSize: 22,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.95))),
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ChipButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.16),
          border: Border.all(
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.12)),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.92),
              fontWeight: FontWeight.w900,
              fontSize: 12.5),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.75),
          fontWeight: FontWeight.w900,
          fontSize: 12.5,
        ),
      ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final int maxLines;

  const _GlassTextField({
    required this.controller,
    required this.hint,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.16),
        border: Border.all(
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 14.5),
        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.45),
              fontWeight: FontWeight.w700),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}

class _GoalChip extends StatelessWidget {
  final int min;
  final bool selected;
  final VoidCallback onTap;

  const _GoalChip({required this.min, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 44,
        constraints: const BoxConstraints(minWidth: 72),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? (Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15)
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14))
              : (Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05)
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.07)),
          border: Border.all(
              color: selected
                  ? (Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.22))
                  : (Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.12))),
        ),
        child: Text(
          l10n.minutesShort(min),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 13),
        ),
      ),
    );
  }
}
