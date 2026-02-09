import 'package:flutter/material.dart';

import '../../core/widgets/glass.dart';
import '../../data/chat_repository.dart';
import 'dm_chat_screen.dart';
import 'select_friend_screen.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}



class _InboxScreenState extends State<InboxScreen> {
  final String meId = "me"; // later: auth user id
  String query = "";

  // Demo map: userId -> display name
  final Map<String, String> idToName = const {
    "1": "Mina",
    "2": "Kenji",
    "3": "Sara",
    "4": "Diego",
    "5": "Aisha",
  };

  @override
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              children: [
                // Top
                Row(
                  children: [
                    _IconGlass(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                     Text(
                      l10n.inboxTitle,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    _IconGlass(
                      icon: Icons.edit_rounded,
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SelectFriendScreen()));
                        if (mounted) setState(() {});
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Search
                Glass(
                  radius: BorderRadius.circular(20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          color: scheme.onSurface.withValues(alpha: 0.7)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => query = v),
                          style: TextStyle(
                              color: scheme.onSurface, fontWeight: FontWeight.w700),
                          cursorColor: scheme.onSurface,
                          decoration: InputDecoration(
                            hintText: l10n.searchChatsHint,
                            hintStyle: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.45)),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (query.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() => query = ""),
                          child: Icon(Icons.close_rounded,
                              color: scheme.onSurface.withValues(alpha: 0.7)),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: chatRepository.getInboxThreads(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF2AFADF)));
                      }

                      final all = snapshot.data ?? [];
                      // Filter by query
                      final filtered = all.where((t) {
                        if (query.trim().isEmpty) return true;
                        final name = (t['otherName'] as String?) ?? '';
                        return name.toLowerCase().contains(query.toLowerCase());
                      }).toList();

                      if (filtered.isEmpty) {
                        return Glass(
                          radius: BorderRadius.circular(22),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            query.isEmpty
                                ? l10n.inboxEmptyState
                                : l10n.noMatchForQuery(query),
                            style: TextStyle(
                              color: scheme.onSurface.withValues(alpha: 0.75),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }

                      return Glass(
                        radius: BorderRadius.circular(22),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: filtered.map((t) {
                            return _ThreadRow(
                              name: t['otherName'] ?? l10n.unknown,
                              lastText: t['lastMsg'] ?? '',
                              time: _fmtTime(t['time'] as DateTime),
                              unreadCount: t['unreadCount'] ?? 0,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DmChatScreen(
                                      meId:
                                          chatRepository.currentUserId ?? "me",
                                      otherId: t['otherId'],
                                      otherName: t['otherName'] ?? l10n.genericUser,
                                    ),
                                  ),
                                );
                                if (mounted) setState(() {}); // refresh list
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  String _fmtTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return "$hh:$mm";
  }
}

// ---------------- UI parts ----------------

class _IconGlass extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconGlass({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Glass(
        radius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: scheme.onSurface.withValues(alpha: 0.92)),
      ),
    );
  }
}

class _ThreadRow extends StatelessWidget {
  final String name;
  final String lastText;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const _ThreadRow({
    required this.name,
    required this.lastText,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final highlight = unreadCount > 0;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: highlight
                ? scheme.onSurface.withValues(alpha: 0.10)
                : scheme.onSurface.withValues(alpha: 0.06),
            border: Border.all(
              color: highlight
                  ? scheme.onSurface.withValues(alpha: 0.24)
                  : scheme.onSurface.withValues(alpha: 0.14),
            ),
          ),
          child: Row(
            children: [
              _Avatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastText,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.65),
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.55),
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: scheme.primary.withValues(alpha: 0.16),
                        border:
                            Border.all(color: scheme.primary.withValues(alpha: 0.22)),
                      ),
                      child: Text(
                        unreadCount.toString(),
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    )
                  else
                    Icon(Icons.chevron_right_rounded,
                        color: scheme.onSurface.withValues(alpha: 0.45)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.onSurface.withValues(alpha: 0.10),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.16)),
      ),
      child: Center(
        child: Text(
          "🙂",
          style: TextStyle(fontSize: 18, color: scheme.onSurface.withValues(alpha: 0.9)),
        ),
      ),
    );
  }
}
