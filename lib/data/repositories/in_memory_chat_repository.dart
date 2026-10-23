import 'dart:async';
import 'package:bidart/domain/models/chat/chat_message.dart';
import 'package:bidart/domain/models/chat/conversation_summary.dart';
import 'package:bidart/domain/repositories/chat_repository.dart';

class InMemoryChatRepository implements ChatRepository {
  final Map<String, List<ChatMessage>> _conversations = {};
  final StreamController<Map<String, List<ChatMessage>>> _streamController =
      StreamController<Map<String, List<ChatMessage>>>.broadcast();

  String _conversationKey(String a, String b) {
    final list = [a, b]..sort();
    return list.join('___');
  }

  @override
  Future<List<ChatMessage>> getMessages({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final key = _conversationKey(currentUserId, otherUserId);
    return List.unmodifiable(_conversations[key] ?? []);
  }

  @override
  Future<ChatMessage> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
    bool isInvitation = false,
  }) async {
    final key = _conversationKey(senderId, receiverId);
    final message = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      createdAt: DateTime.now(),
      isInvitation: isInvitation,
    );

    final list = _conversations.putIfAbsent(key, () => []);
    list.add(message);
    _streamController.add(Map.unmodifiable(_conversations));
    return message;
  }

  @override
  Stream<List<ChatMessage>> watchMessages({
    required String currentUserId,
    required String otherUserId,
  }) async* {
    final key = _conversationKey(currentUserId, otherUserId);
    yield List.unmodifiable(_conversations[key] ?? []);

    await for (final all in _streamController.stream) {
      yield List.unmodifiable(all[key] ?? []);
    }
  }

  @override
  Stream<List<ConversationSummary>> watchConversations(String currentUserId) async* {
    List<ConversationSummary> extract(Map<String, List<ChatMessage>> all) {
      final result = <ConversationSummary>[];
      for (final entry in all.entries) {
        final parts = entry.key.split('___');
        if (parts.contains(currentUserId) && entry.value.isNotEmpty) {
          final otherId = parts[0] == currentUserId ? parts[1] : parts[0];
          result.add(
            ConversationSummary(
              otherUserId: otherId,
              lastMessage: entry.value.last,
            ),
          );
        }
      }
      result.sort((a, b) => b.lastMessage.createdAt.compareTo(a.lastMessage.createdAt));
      return result;
    }

    yield extract(_conversations);
    await for (final all in _streamController.stream) {
      yield extract(all);
    }
  }
}
