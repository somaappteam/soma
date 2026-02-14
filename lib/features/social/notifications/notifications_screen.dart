import 'package:flutter/material.dart';
import 'package:soma/l10n/gen/app_localizations.dart';
import '../../../core/widgets/glass.dart';
import '../../../data/notifications_store.dart';
import '../../../data/notifications_repository.dart';
import '../../../data/auth_repository.dart';
import '../../../core/widgets/responsive.dart';
import '../../../core/theme/spacing.dart';

import '../../../data/circles_repository.dart';
import '../../../data/social_repository.dart';
import '../../circles/circle_lobby_screen.dart';

enum NotificationsTab { all, courses, social, circles, system }

class _TabItem {
  final NotificationsTab value;
  final String label;
  const _TabItem(this.value, this.label);
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsTab tab = NotificationsTab.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isGuest = authRepository.currentUser == null;
    final tabs = isGuest
        ? [
            _TabItem(NotificationsTab.all, l10n.notificationsTabAll),
            _TabItem(NotificationsTab.courses, l10n.notificationsTabCourses),
            _TabItem(NotificationsTab.system, l10n.notificationsTabSystem),
          ]
        : [
            _TabItem(NotificationsTab.all, l10n.notificationsTabAll),
            _TabItem(NotificationsTab.courses, l10n.notificationsTabCourses),
            _TabItem(NotificationsTab.social, l10n.notificationsTabSocial),
            _TabItem(NotificationsTab.circles, l10n.notificationsTabCircles),
            _TabItem(NotificationsTab.system, l10n.notificationsTabSystem),
          ];
    final activeTab = tabs.any((t) => t.value == tab) ? tab : tabs.first.value;

    return Scaffold(
      body: SafeArea(
          child: ResponsiveFrame(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(S.lg, S.md, S.lg, S.sm),
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
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.notificationsTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const Spacer(),
                      if (!isGuest)
                        Glass(
                          radius: BorderRadius.circular(14),
                          padding: EdgeInsets.zero,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => notificationsRepository.markAllAsRead(),
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Center(
                                child: Icon(
                                  Icons.done_all_rounded,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: S.md),
                  _Tabs(
                    value: activeTab,
                    tabs: tabs,
                    onChanged: (v) => setState(() => tab = v),
                  ),
                  const SizedBox(height: S.sm),
                  Expanded(
                    child: isGuest
                        ? _buildGuestNotifications(context, activeTab)
                        : StreamBuilder<List<Map<String, dynamic>>>(
                            stream: notificationsRepository.getNotificationsStream(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const _NotificationsSkeleton();
                              }
                              if (snapshot.hasError) {
                                return _NotificationsEmptyState(
                                  title: l10n.notificationsEmpty,
                                  subtitle: _tabDescription(context, activeTab),
                                );
                              }

                              final items = (snapshot.data ?? []).map(_mapNotification).toList();
                              final filtered = items.where((n) {
                                switch (activeTab) {
                                  case NotificationsTab.courses:
                                    return n.type == NotifType.course;
                                  case NotificationsTab.social:
                                    return n.type == NotifType.social;
                                  case NotificationsTab.circles:
                                    return n.type == NotifType.circle;
                                  case NotificationsTab.system:
                                    return n.type == NotifType.system;
                                  default:
                                    return true;
                                }
                              }).toList();

                              if (filtered.isEmpty) {
                                return _NotificationsEmptyState(
                                  title: l10n.notificationsEmpty,
                                  subtitle: _tabDescription(context, activeTab),
                                );
                              }

                              return ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) => const SizedBox(height: S.sm),
                                itemBuilder: (_, i) {
                                  final n = filtered[i];

                                  return Dismissible(
                                    key: ValueKey(n.id),
                                    direction: DismissDirection.endToStart,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: S.md),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error
                                              .withValues(alpha: 0.18),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.10),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.delete_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.92),
                                        ),
                                      ),
                                    onDismissed: (_) {
                                      notificationsRepository.deleteNotification(n.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(l10n.notificationsDeleted)),
                                      );
                                    },
                                    child: _NotifCard(
                                      n: n,
                                      onTap: () => notificationsRepository.markAsRead(n.id),
                                      onPrimaryAction: () => _handlePrimary(context, n),
                                      onSecondaryAction: () => _handleSecondary(context, n),
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

  String _tabDescription(BuildContext context, NotificationsTab tab) {
    final l10n = AppLocalizations.of(context);
    switch (tab) {
      case NotificationsTab.courses:
        return l10n.notificationsTabCourses;
      case NotificationsTab.social:
        return l10n.notificationsTabSocial;
      case NotificationsTab.circles:
        return l10n.notificationsTabCircles;
      case NotificationsTab.system:
        return l10n.notificationsTabSystem;
      case NotificationsTab.all:
        return l10n.notificationsTabAll;
    }
  }

  Widget _buildGuestNotifications(BuildContext context, NotificationsTab activeTab) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: notificationsStore,
      builder: (context, _) {
        final items = notificationsStore.items
            .where((n) => n.type == NotifType.course || n.type == NotifType.system)
            .toList();
        final filtered = items.where((n) {
          switch (activeTab) {
            case NotificationsTab.courses:
              return n.type == NotifType.course;
            case NotificationsTab.system:
              return n.type == NotifType.system;
            default:
              return true;
          }
        }).toList();

        if (filtered.isEmpty) {
          return _NotificationsEmptyState(
            title: l10n.notificationsEmpty,
            subtitle: _tabDescription(context, activeTab),
          );
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: S.sm),
          itemBuilder: (_, i) {
            final n = filtered[i];

            return Dismissible(
              key: ValueKey(n.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: S.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.18),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.10),
                  ),
                ),
                child: Icon(
                  Icons.delete_rounded,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.92),
                ),
              ),
              onDismissed: (_) {
                notificationsStore.delete(n.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.notificationsDeleted)),
                );
              },
              child: _NotifCard(
                n: n,
                onTap: () => notificationsStore.markRead(n.id),
                onPrimaryAction: () => _handlePrimaryGuest(context, n),
                onSecondaryAction: null,
              ),
            );
          },
        );
      },
    );
  }

  AppNotification _mapNotification(Map<String, dynamic> row) {
    final l10n = AppLocalizations.of(context);
    final metadataRaw = row['metadata'];
    final metadata = metadataRaw is Map
        ? Map<String, dynamic>.from(metadataRaw)
        : <String, dynamic>{};
    final rawType = row['type']?.toString();
    final time = _parseTime(row['created_at']);
    final isRead = row['is_read'] == true || row['is_read'] == 1;

    final socialActionRaw = metadata['social_action'] ?? metadata['action'] ?? row['social_action'] ?? row['action'];
    final socialAction = socialActionRaw?.toString() == 'friend_request'
        ? SocialAction.friendRequest
        : null;

    final circleActionRaw = metadata['circle_action'] ?? metadata['action'] ?? row['circle_action'];
    final circleAction = circleActionRaw?.toString() == 'invite' ? CircleAction.invite : null;

    final courseActionRaw = metadata['course_action'] ?? row['course_action'] ?? metadata['action'];
    final courseAction = courseActionRaw?.toString() == 'daily_goal' ? CourseAction.dailyGoal : null;

    final friendshipIdRaw = metadata['friendship_id'] ?? row['friendship_id'];

    final inferredType = socialAction != null
        ? NotifType.social
        : circleAction != null
            ? NotifType.circle
            : courseAction != null
                ? NotifType.course
                : _parseType(rawType);

    return AppNotification(
      id: row['id'].toString(),
      type: inferredType,
      title: row['title'] ?? (socialAction == SocialAction.friendRequest
          ? 'New friend request'
          : l10n.notificationTitleFallback),
      body: row['body'] ?? (socialAction == SocialAction.friendRequest
          ? '${metadata['from_user_name']?.toString() ?? l10n.userFallbackName} sent you a friend request.'
          : ''),
      time: time,
      isRead: isRead,
      socialAction: socialAction,
      fromUserId: metadata['from_user_id']?.toString(),
      fromUserName: metadata['from_user_name']?.toString(),
      friendshipId: friendshipIdRaw?.toString(),
      circleAction: circleAction,
      circleId: (metadata['circle_id'] ?? row['circle_id'])?.toString(),
      circleTitle: (metadata['circle_title'] ?? row['circle_title'])?.toString(),
      courseAction: courseAction,
      courseId: (metadata['course_id'] ?? row['course_id'])?.toString(),
    );
  }

  NotifType _parseType(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'course':
        return NotifType.course;
      case 'social':
        return NotifType.social;
      case 'circle':
        return NotifType.circle;
      case 'system':
      default:
        return NotifType.system;
    }
  }

  DateTime _parseTime(dynamic raw) {
    if (raw is DateTime) return raw;
    if (raw is String) {
      return DateTime.tryParse(raw) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Future<void> _handlePrimary(BuildContext context, AppNotification n) async {
    final l10n = AppLocalizations.of(context);
    await notificationsRepository.markAsRead(n.id);
    if (n.type == NotifType.social && n.socialAction == SocialAction.friendRequest) {
      try {
        if (n.friendshipId == null && n.fromUserId == null) {
          throw StateError('Missing request identity for friend request action.');
        }
        if (n.friendshipId != null) {
          await socialRepository.acceptFriendRequest(n.friendshipId!);
        } else if (n.fromUserId != null) {
          await socialRepository.acceptFriendRequestFromUser(n.fromUserId!);
        }
        await notificationsRepository.deleteNotification(n.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.notificationsFriendAccepted)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.notificationsFriendAcceptFailed(e.toString()))),
          );
        }
      }
      return;
    }
    if (n.type == NotifType.circle && n.circleAction == CircleAction.invite && n.circleId != null) {
      try {
        final outcome = await circlesRepository.joinCircleFromInvite(n.circleId!);
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CircleLobbyScreen(circleId: n.circleId!),
          ),
        );
        final label = outcome.role == 'player'
            ? l10n.circleJoinedAsPlayer
            : l10n.circleJoinedAsSpectator;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.notificationsJoinCircleFailed(e.toString()))),
        );
      }
      return;
    }
    final label = n.type == NotifType.system
        ? l10n.notificationsOpened
        : l10n.notificationsOpening;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.notificationsActionMessage(label))),
      );
    }
  }

  Future<void> _handlePrimaryGuest(BuildContext context, AppNotification n) async {
    final l10n = AppLocalizations.of(context);
    notificationsStore.markRead(n.id);
    final label = n.type == NotifType.system
        ? l10n.notificationsOpened
        : l10n.notificationsOpening;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.notificationsActionMessage(label))),
      );
    }
  }

  Future<void> _handleSecondary(BuildContext context, AppNotification n) async {
    final l10n = AppLocalizations.of(context);
    if (n.type == NotifType.social && n.socialAction == SocialAction.friendRequest) {
      try {
        if (n.friendshipId == null && n.fromUserId == null) {
          throw StateError('Missing request identity for friend request action.');
        }
        if (n.friendshipId != null) {
          await socialRepository.declineFriendRequest(n.friendshipId!);
        } else if (n.fromUserId != null) {
          await socialRepository.declineFriendRequestFromUser(n.fromUserId!);
        }
        await notificationsRepository.deleteNotification(n.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.notificationsFriendDeclined)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.notificationsFriendDeclineFailed(e.toString()))),
          );
        }
      }
      return;
    }

    if (n.type == NotifType.circle && n.circleAction == CircleAction.invite) {
      await notificationsRepository.deleteNotification(n.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.notificationsDeleted)),
        );
      }
      return;
    }
  }
}

class _Tabs extends StatelessWidget {
  final NotificationsTab value;
  final ValueChanged<NotificationsTab> onChanged;
  final List<_TabItem> tabs;
  const _Tabs({required this.value, required this.onChanged, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Glass(
      radius: BorderRadius.circular(999),
      padding: const EdgeInsets.all(S.xs),
      child: Row(
        children: tabs.map((t) {
          final selected = t.value == value;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onChanged(t.value),
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: selected ? scheme.primary.withValues(alpha: 0.16) : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? scheme.primary.withValues(alpha: 0.35)
                        : Colors.transparent,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  t.label,
                  style: TextStyle(
                    color: selected
                        ? scheme.onSurface.withValues(alpha: 0.95)
                        : scheme.onSurface.withValues(alpha: 0.65),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final AppNotification n;
  final VoidCallback onTap;
  final VoidCallback onPrimaryAction;
  final VoidCallback? onSecondaryAction;

  const _NotifCard({
    required this.n,
    required this.onTap,
    required this.onPrimaryAction,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _iconFor(n.type);
    final label = _labelFor(context, n.type);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Glass(
      radius: BorderRadius.circular(24),
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(S.sm, S.sm, S.sm, S.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBubble(icon: icon, isRead: n.isRead),
              const SizedBox(width: S.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          label,
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.65),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _fmtTime(context, n.time),
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.55),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: S.xs),
                    Text(
                      n.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: n.isRead ? 0.85 : 1),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: S.xxs),
                    Text(
                      n.body,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.65),
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: S.sm),
                    _ActionRow(
                      n: n,
                      onPrimary: onPrimaryAction,
                      onSecondary: onSecondaryAction,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: S.sm),
              if (!n.isRead)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.secondary,
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.35),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(width: 10, height: 10),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(NotifType t) {
    switch (t) {
      case NotifType.course:
        return Icons.school_rounded;
      case NotifType.social:
        return Icons.people_alt_rounded;
      case NotifType.circle:
        return Icons.radio_button_checked_rounded;
      case NotifType.system:
        return Icons.auto_awesome_rounded;
    }
  }

  static String _labelFor(BuildContext context, NotifType t) {
    final l10n = AppLocalizations.of(context);
    switch (t) {
      case NotifType.course:
        return l10n.notificationTypeCourse;
      case NotifType.social:
        return l10n.notificationTypeSocial;
      case NotifType.circle:
        return l10n.notificationTypeCircle;
      case NotifType.system:
        return l10n.notificationTypeSystem;
    }
  }

  static String _fmtTime(BuildContext context, DateTime dt) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return l10n.timeShortMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeShortHours(diff.inHours);
    return l10n.timeShortDays(diff.inDays);
  }
}

class _ActionRow extends StatelessWidget {
  final AppNotification n;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;

  const _ActionRow({required this.n, required this.onPrimary, this.onSecondary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (n.type == NotifType.social && n.socialAction == SocialAction.friendRequest) {
      return Row(
        children: [
          _ChipButton(label: l10n.accept, onTap: onPrimary),
          const SizedBox(width: 10),
          _ChipButton(label: l10n.decline, onTap: onSecondary ?? () {}),
        ],
      );
    }

    if (n.type == NotifType.circle && n.circleAction == CircleAction.invite) {
      return Row(
        children: [
          _ChipButton(label: l10n.joinCircle, onTap: onPrimary),
          const SizedBox(width: 10),
          _ChipButton(label: l10n.decline, onTap: onSecondary ?? () {}),
        ],
      );
    }

    if (n.type == NotifType.course && n.courseAction == CourseAction.dailyGoal) {
      return Row(
        children: [
          _ChipButton(label: l10n.open, onTap: onPrimary),
        ],
      );
    }

    return Row(
      children: [
        _ChipButton(label: l10n.open, onTap: onPrimary),
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ChipButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: S.sm, vertical: S.xs),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
          border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.92),
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;
  final bool isRead;
  const _IconBubble({required this.icon, required this.isRead});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: scheme.surfaceContainerHighest.withValues(alpha: isRead ? 0.5 : 0.75),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.14)),
      ),
      child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.92), size: 22),
    );
  }
}

class _NotificationsEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const _NotificationsEmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Glass(
      radius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(S.lg),
      child: SizedBox(
        width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_none_rounded, color: scheme.primary, size: 28),
          const SizedBox(height: S.sm),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.9),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: S.xs),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _NotificationsSkeleton extends StatelessWidget {
  const _NotificationsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: S.sm),
      itemBuilder: (context, index) => const _NotificationsSkeletonCard(),
    );
  }
}

class _NotificationsSkeletonCard extends StatelessWidget {
  const _NotificationsSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.3, end: 0.7),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final base = scheme.onSurface.withValues(alpha: 0.08 + (0.06 * value));
        return Container(
          padding: const EdgeInsets.all(S.sm),
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: base.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(width: S.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonLine(width: 120, color: base.withValues(alpha: 0.9)),
                    const SizedBox(height: S.xs),
                    _SkeletonLine(width: 200, color: base.withValues(alpha: 0.8)),
                    const SizedBox(height: S.xs),
                    _SkeletonLine(width: 160, color: base.withValues(alpha: 0.7)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;
  final Color color;
  const _SkeletonLine({required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
