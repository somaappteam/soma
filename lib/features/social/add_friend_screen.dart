import 'package:flutter/material.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../data/social_repository.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final controller = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final username = controller.text.trim();
    if (username.isEmpty) return;

    final l10n = AppLocalizations.of(context);
    setState(() => loading = true);

    try {
      // 1. Find user by username
      final users = await socialRepository.searchUsers(username);
      // Optional: approximate match logic or pick first exact
      final target = users.firstWhere(
        (u) =>
            (u['username'] as String).toLowerCase() == username.toLowerCase(),
        orElse: () => {},
      );

      if (target.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.addFriendUserNotFound(username))),
          );
          setState(() => loading = false);
        }
        return;
      }

      final addresseeId = target['id'];
      if (addresseeId == socialRepository.currentUserId) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.profileCantAddYourself)),
          );
          setState(() => loading = false);
        }
        return;
      }

      // 2. Send Request
      await socialRepository.sendFriendRequest(addresseeId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileRequestSent(username))),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.addFriendRequestFailed(e.toString()))),
        );
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              children: [
                Row(
                  children: [
                    _IconGlass(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.addFriendTitle,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Glass(
                  radius: BorderRadius.circular(22),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addFriendFindByUsername,
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.75),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Glass(
                        radius: BorderRadius.circular(18),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        child: TextField(
                          controller: controller,
                          style: TextStyle(
                              color: scheme.onSurface, fontWeight: FontWeight.w800),
                          cursorColor: scheme.primary,
                          decoration: InputDecoration(
                            hintText: l10n.addFriendUsernameHint,
                            hintStyle: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.45)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.addFriendTip,
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.55),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                NeonButton(
                  label: loading ? l10n.addFriendSending : l10n.addFriendSendRequest,
                  onTap: loading ? () {} : _send,
                ),
              ],
            ),
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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92)),
      ),
    );
  }
}
