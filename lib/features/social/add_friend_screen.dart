import 'package:flutter/material.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../data/social_repository.dart';

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
            SnackBar(content: Text("User @$username not found")),
          );
          setState(() => loading = false);
        }
        return;
      }

      final addresseeId = target['id'];
      if (addresseeId == socialRepository.currentUserId) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You can't add yourself")),
          );
          setState(() => loading = false);
        }
        return;
      }

      // 2. Send Request
      await socialRepository.sendFriendRequest(addresseeId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request sent to @$username")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Action failed or already sent: $e")),
        );
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      "Add Friend",
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
                        "Find by username",
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
                            hintText: "Type username…",
                            hintStyle: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.45)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Tip: later we can support QR code + friend ID.",
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
                  label: loading ? "Sending..." : "Send Request",
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
