import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/features/chat/provider/chat_providers.dart';
import 'package:bidart/models/mock_user.dart';
import 'package:bidart/screens/people/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatListScreen extends ConsumerWidget {
  final VoidCallback? onExplorePeople;

  const ChatListScreen({
    super.key,
    this.onExplorePeople,
  });

  User _resolveUser(String userId) {
    try {
      return mockOpponents.firstWhere((u) => u.id == userId);
    } catch (_) {
      return User(
        id: userId,
        name: 'Đối thủ',
        phone: '',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(recentConversationsProvider);
    final theme = Theme.of(context);

    return conversationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Lỗi tải danh sách chat: $err')),
      data: (conversations) {
        if (conversations.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Chưa có cuộc trò chuyện nào',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thách đấu các cơ thủ trong mục People để bắt đầu kết nối trò chuyện và hẹn kèo!',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (onExplorePeople != null)
                    FilledButton.icon(
                      onPressed: onExplorePeople,
                      icon: const Icon(Icons.people_alt_outlined),
                      label: const Text('Tìm đối thủ ngay'),
                    ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: conversations.length,
          separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
          itemBuilder: (context, index) {
            final item = conversations[index];
            final partner = _resolveUser(item.otherUserId);
            final lastMsg = item.lastMessage;
            final timeStr =
                '${lastMsg.createdAt.hour.toString().padLeft(2, '0')}:${lastMsg.createdAt.minute.toString().padLeft(2, '0')}';

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: partner.avatarUrl != null &&
                        partner.avatarUrl!.isNotEmpty
                    ? NetworkImage(partner.avatarUrl!)
                    : null,
                child: partner.avatarUrl == null || partner.avatarUrl!.isEmpty
                    ? Text(
                        partner.name.isNotEmpty
                            ? partner.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      partner.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    if (lastMsg.isInvitation) ...[
                      const Icon(
                        Icons.flash_on,
                        size: 15,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '[Lời mời thách đấu] ',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    Expanded(
                      child: Text(
                        lastMsg.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ChatScreen(opponent: partner),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
