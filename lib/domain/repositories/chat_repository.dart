import 'package:bidart/domain/models/chat/chat_message.dart';
import 'package:bidart/domain/models/chat/conversation_summary.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> getMessages({
    required String currentUserId,
    required String otherUserId,
  });

  Future<ChatMessage> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
    bool isInvitation = false,
  });

  Stream<List<ChatMessage>> watchMessages({
    required String currentUserId,
    required String otherUserId,
  });

  Stream<List<ConversationSummary>> watchConversations(String currentUserId);
}
