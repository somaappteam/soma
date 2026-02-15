import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/widgets/glass.dart';
import '../../core/widgets/neon_button.dart';
import '../../data/social_repository.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../profile/profile_screen.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final controller = TextEditingController();
  bool loading = false;
  
  // Search state
  Timer? _debounce;
  List<Map<String, dynamic>> _searchResults = [];
  bool _searching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _searching = false;
      });
      return;
    }

    setState(() => _searching = true);
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await socialRepository.searchUsers(query);
        if (!mounted) return;
        setState(() {
          _searchResults = results;
          _searching = false;
        });
      } catch (e) {
        debugPrint("Search error: $e");
        if (mounted) setState(() => _searching = false);
      }
    });
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
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compactHeight = constraints.maxHeight < 760;
              final keyboardVisible = keyboardInset > 0;
              final topSpacing = compactHeight ? 12.0 : 16.0;
              final sectionSpacing = compactHeight ? 10.0 : 12.0;
              final resultListHeight = keyboardVisible
                  ? (compactHeight ? 110.0 : 130.0)
                  : (compactHeight ? 160.0 : 200.0);

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                      child: Column(
                        children: [
                        Row(
                          children: [
                            _IconGlass(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.addFriendTitle,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: scheme.onSurface,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: topSpacing),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            child: Glass(
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
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: controller,
                                            onChanged: _onSearchChanged,
                                            style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w800),
                                            cursorColor: scheme.primary,
                                            decoration: InputDecoration(
                                              hintText: l10n.addFriendUsernameHint,
                                              hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.45)),
                                              border: InputBorder.none,
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                        if (_searching)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: scheme.primary,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: sectionSpacing),
                                  if (_searchResults.isNotEmpty) ...[
                                    ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: resultListHeight),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _searchResults.length,
                                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                                        itemBuilder: (context, index) {
                                          final user = _searchResults[index];
                                          return _SearchResultRow(
                                            user: user,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ProfileScreen(userId: user['id']),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ] else ...[
                                    Text(
                                      l10n.addFriendTip,
                                      style: TextStyle(
                                        color: scheme.onSurface.withValues(alpha: 0.55),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedPadding(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.only(
                            top: compactHeight ? 10 : 14,
                            bottom: math.min(keyboardInset, 24),
                          ),
                          child: NeonButton(
                            label: loading ? l10n.addFriendSending : l10n.addFriendSendRequest,
                            onTap: loading ? () {} : _send,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                ),
              );
            },
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

class _SearchResultRow extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onTap;

  const _SearchResultRow({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final username = user['username'] ?? "Unknown";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: scheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primary.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  username.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
