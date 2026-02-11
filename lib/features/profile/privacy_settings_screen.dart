import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/premium_dialog.dart';
import '../../data/settings_repository.dart';
import '../../core/widgets/responsive.dart';
import '../../data/auth_repository.dart';
import '../../data/profile_repository.dart';
import '../../data/stats_repository.dart';
import '../../data/privacy_repository.dart';

// Enum definitions (could be in a model file, but keeping here for simplicity as they were in privacy_store)
enum ProfileVisibility { public, friends, private }
enum DmPermission { everyone, friendsOnly, noOne }

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  late Stream<Map<String, dynamic>> _settingsStream;

  @override
  void initState() {
    super.initState();
    _settingsStream = settingsRepository.getSettingsStream();
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
                      _IconBtn(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.privacyTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: StreamBuilder<Map<String, dynamic>>(
                      stream: _settingsStream,
                      builder: (context, snapshot) {
                        // Default values if loading or empty
                        final data = snapshot.data ?? {};
                        
                        final visibility = _parseVisibility(data['profile_visibility']);
                        final showOnline = data['show_online_status'] ?? true;
                        final showActivity = data['show_learning_activity'] ?? true;
                        final allowRequests = data['allow_friend_requests'] ?? true;
                        final dmPermission = _parseDmPermission(data['dm_permission']);
                        final blockedIds = _parseBlockedUsers(data['blocked_user_ids']);

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _SectionTitle(l10n.privacySectionVisibility),
                            _SegmentedChoice(
                              title: l10n.privacyProfileVisibilityTitle,
                              subtitle: _visibilitySubtitle(visibility, l10n),
                              options: [
                                _SegOpt(l10n.privacyVisibilityPublic),
                                _SegOpt(l10n.privacyVisibilityFriends),
                                _SegOpt(l10n.privacyVisibilityPrivate),
                              ],
                              selectedIndex: _visIndex(visibility),
                              onPick: (i) {
                                final v = i == 0
                                    ? ProfileVisibility.public
                                    : i == 1
                                        ? ProfileVisibility.friends
                                        : ProfileVisibility.private;
                                settingsRepository.updateSetting('profile_visibility', v.name);
                              },
                            ),

                            const SizedBox(height: 14),

                            _SectionTitle(l10n.privacySectionActivity),
                            _SwitchTile(
                              icon: Icons.circle_outlined,
                              title: l10n.privacyShowOnlineTitle,
                              subtitle: l10n.privacyShowOnlineSubtitle,
                              value: showOnline,
                              onChanged: (v) => settingsRepository.updateSetting('show_online_status', v),
                            ),
                            const SizedBox(height: 10),
                            _SwitchTile(
                              icon: Icons.bar_chart_rounded,
                              title: l10n.privacyShowActivityTitle,
                              subtitle: l10n.privacyShowActivitySubtitle,
                              value: showActivity,
                              onChanged: (v) => settingsRepository.updateSetting('show_learning_activity', v),
                            ),

                            const SizedBox(height: 14),

                            _SectionTitle(l10n.privacySectionSocial),
                            _SwitchTile(
                              icon: Icons.person_add_alt_1_rounded,
                              title: l10n.privacyAllowRequestsTitle,
                              subtitle: l10n.privacyAllowRequestsSubtitle,
                              value: allowRequests,
                              onChanged: (v) => settingsRepository.updateSetting('allow_friend_requests', v),
                            ),

                            const SizedBox(height: 10),

                            _SegmentedChoice(
                              title: l10n.privacyWhoCanDmTitle,
                              subtitle: _dmSubtitle(dmPermission, l10n),
                              options: [
                                _SegOpt(l10n.privacyDmEveryone),
                                _SegOpt(l10n.privacyDmFriends),
                                _SegOpt(l10n.privacyDmNoOne),
                              ],
                              selectedIndex: _dmIndex(dmPermission),
                              onPick: (i) {
                                final p = i == 0
                                    ? DmPermission.everyone
                                    : i == 1
                                        ? DmPermission.friendsOnly
                                        : DmPermission.noOne;
                                settingsRepository.updateSetting('dm_permission', p.name);
                              },
                            ),

                            const SizedBox(height: 14),

                            _SectionTitle(l10n.privacySectionBlockedUsers),
                            _Tile(
                              icon: Icons.block_rounded,
                              title: l10n.privacySectionBlockedUsers,
                              subtitle: blockedIds.isEmpty
                                  ? AppLocalizations.of(context).privacyBlockedUsersComingSoon
                                  : "${blockedIds.length} blocked",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => _BlockedUsersScreen(
                                      blockedIds: blockedIds,
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 14),

                            _SectionTitle(l10n.privacySectionDataControls),
                            _Tile(
                              icon: Icons.file_download_rounded,
                              title: l10n.privacyExportDataTitle,
                              subtitle: l10n.privacyExportDataSubtitle,
                              onTap: () => _exportData(context),
                            ),
                            const SizedBox(height: 10),
                            _TileDanger(
                              icon: Icons.delete_forever_rounded,
                              title: l10n.privacyDeleteAccountTitle,
                              subtitle: l10n.privacyDeleteAccountSubtitle,
                              onTap: () => _confirmDelete(context),
                            ),

                            const SizedBox(height: 10),
                          ],
                        );
                      }
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  // --- Parsers ---

  ProfileVisibility _parseVisibility(String? v) {
    return ProfileVisibility.values.firstWhere((e) => e.name == v, orElse: () => ProfileVisibility.friends);
  }

  DmPermission _parseDmPermission(String? v) {
    return DmPermission.values.firstWhere((e) => e.name == v, orElse: () => DmPermission.friendsOnly);
  }

  int _visIndex(ProfileVisibility v) {
    switch (v) {
      case ProfileVisibility.public: return 0;
      case ProfileVisibility.friends: return 1;
      case ProfileVisibility.private: return 2;
    }
  }

  String _visibilitySubtitle(ProfileVisibility v, AppLocalizations l10n) {
    switch (v) {
      case ProfileVisibility.public: return l10n.privacyVisibilityPublicSubtitle;
      case ProfileVisibility.friends: return l10n.privacyVisibilityFriendsSubtitle;
      case ProfileVisibility.private: return l10n.privacyVisibilityPrivateSubtitle;
    }
  }

  int _dmIndex(DmPermission p) {
    switch (p) {
      case DmPermission.everyone: return 0;
      case DmPermission.friendsOnly: return 1;
      case DmPermission.noOne: return 2;
    }
  }

  String _dmSubtitle(DmPermission p, AppLocalizations l10n) {
    switch (p) {
      case DmPermission.everyone: return l10n.privacyDmEveryoneSubtitle;
      case DmPermission.friendsOnly: return l10n.privacyDmFriendsSubtitle;
      case DmPermission.noOne: return l10n.privacyDmNoOneSubtitle;
    }
  }

  void _showInfo(BuildContext context, String title, String body) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _InfoSheet(title: title, body: body),
    );
  }

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showPremiumDialog(
      context: context,
      title: l10n.privacyDeleteConfirmTitle,
      body: l10n.privacyDeleteConfirmBody,
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      destructive: true,
    ).then((confirmed) {
      if (confirmed != true) return;
      _deleteAccount(context);
    });
  }

  List<String> _parseBlockedUsers(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }

  Future<void> _exportData(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final profile = await profileRepository.fetchProfile();
      final settings = await settingsRepository.getSettings();
      final stats = await statsRepository.getStats();
      final payload = {
        'profile': {
          'id': profile?.id,
          'display_name': profile?.displayName,
          'username': profile?.username,
          'bio': profile?.bio,
          'location': profile?.location,
          'daily_goal_minutes': profile?.dailyGoalMinutes,
          'total_xp': profile?.totalXp,
        },
        'stats': {
          'total_wins': stats.totalWins,
          'streak_days': stats.streakDays,
          'longest_streak': stats.longestStreak,
          'total_quizzes': stats.totalQuizzes,
          'total_correct': stats.totalCorrect,
          'total_questions': stats.totalQuestions,
          'perfect_quizzes': stats.perfectQuizzes,
          'circles_joined': stats.circlesJoined,
          'last_active_date': stats.lastActiveDate?.toIso8601String(),
        },
        'settings': settings,
        'exported_at': DateTime.now().toIso8601String(),
      };
      final jsonData = const JsonEncoder.withIndent('  ').convert(payload);
      await Share.share(jsonData, subject: 'Soma data export');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorWithDetails(e.toString()))),
      );
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await privacyRepository.requestAccountDeletion();
      await authRepository.signOutWithSessionEnd();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deletion request submitted.'),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorWithDetails(e.toString()))),
      );
    }
  }
}

class _BlockedUsersScreen extends StatefulWidget {
  final List<String> blockedIds;
  const _BlockedUsersScreen({required this.blockedIds});

  @override
  State<_BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<_BlockedUsersScreen> {
  late List<String> _blockedIds;
  late Future<List<Map<String, dynamic>>> _profilesFuture;

  @override
  void initState() {
    super.initState();
    _blockedIds = List<String>.from(widget.blockedIds);
    _profilesFuture = profileRepository.getProfilesByIds(_blockedIds);
  }

  Future<void> _unblock(String userId) async {
    setState(() {
      _blockedIds = _blockedIds.where((id) => id != userId).toList();
      _profilesFuture = profileRepository.getProfilesByIds(_blockedIds);
    });
    await settingsRepository.updateSetting('blocked_user_ids', _blockedIds);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                    _IconBtn(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.privacySectionBlockedUsers,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _blockedIds.isEmpty
                      ? Glass(
                          radius: BorderRadius.circular(24),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            l10n.privacyBlockedUsersComingSoon,
                            style: TextStyle(
                              color: scheme.onSurface.withValues(alpha: 0.75),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : FutureBuilder<List<Map<String, dynamic>>>(
                          future: _profilesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final profiles = snapshot.data ?? [];
                            return ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: profiles.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final profile = profiles[index];
                                final id = profile['id']?.toString() ?? '';
                                return Glass(
                                  radius: BorderRadius.circular(24),
                                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                                  child: Row(
                                    children: [
                                      _IconBox(icon: Icons.person_rounded),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              profile['username'] ?? l10n.genericUser,
                                              style: TextStyle(
                                                color: scheme.onSurface,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              profile['display_name'] ?? '',
                                              style: TextStyle(
                                                color: scheme.onSurface.withValues(alpha: 0.62),
                                                fontWeight: FontWeight.w700,
                                                height: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: id.isEmpty ? null : () => _unblock(id),
                                        child: Text(l10n.remove),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
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

// ---------------- UI components ----------------

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

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
          child: Center(child: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9), size: 20)),
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
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
          fontWeight: FontWeight.w900,
          fontSize: 12.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(24),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        children: [
          _IconBox(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62), fontWeight: FontWeight.w700, height: 1.2)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeThumbColor: const Color(0xFF2AFADF)),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  const _IconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92), size: 22),
    );
  }
}

class _SegOpt {
  final String label;
  const _SegOpt(this.label);
}

class _SegmentedChoice extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<_SegOpt> options;
  final int selectedIndex;
  final ValueChanged<int> onPick;

  const _SegmentedChoice({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedIndex,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(24),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 15)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62), fontWeight: FontWeight.w700, height: 1.2)),
          const SizedBox(height: 12),
          Row(
            children: List.generate(options.length, (i) {
              final selected = i == selectedIndex;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => onPick(i),
                  child: Container(
                    height: 44,
                    margin: EdgeInsets.only(right: i == options.length - 1 ? 0 : 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: selected
                          ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: selected ? 0.22 : 0.10)),
                    ),
                    child: Text(
                      options[i].label,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: selected ? 0.95 : 0.75),
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}
 
class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
 
  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(24),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: [
              _IconBox(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62), fontWeight: FontWeight.w700, height: 1.2)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75)),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _TileDanger extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
 
  const _TileDanger({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: BorderRadius.circular(24),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: [
              _IconBox(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62), fontWeight: FontWeight.w700, height: 1.2)),
                  ],
                ),
              ),
              Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.onErrorContainer.withValues(alpha: 0.85)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSheet extends StatelessWidget {
  final String title;
  final String body;
  const _InfoSheet({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Glass(
        radius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 8),
            Text(body, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70), fontWeight: FontWeight.w700, height: 1.2)),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 46,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.10),
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14)),
                ),
                alignment: Alignment.center,
                child: Text(l10n.ok, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
