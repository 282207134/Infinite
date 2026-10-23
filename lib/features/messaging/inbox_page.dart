import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app_scope.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});
  @override
  Widget build(BuildContext context) {
    final messages = AppScope.of(context).messages;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const PageHeader(
          title: 'Inbox',
          eyebrow: 'Good conversations lead to great work',
        ),
        const SizedBox(height: 12),
        InkWell(
          key: const ValueKey('open-chat'),
          onTap: () => openChat(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Avatar('mary', size: 50),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerifiedName('Mary Jane Watson', verified: false),
                      const SizedBox(height: 7),
                      Text(
                        messages.isEmpty
                            ? 'Thanks a lot. Catch you soon, Tiger!'
                            : messages.last,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '09:41',
                  style: TextStyle(fontSize: 11, color: Palette.muted),
                ),
              ],
            ),
          ),
        ),
        const Divider(indent: 20, endIndent: 20),
        const EmptyState(
          title: 'Room for your next idea',
          message:
              'Connect with a creative from their profile\nand start a conversation.',
          icon: CupertinoIcons.chat_bubble_2,
        ),
      ],
    );
  }
}
