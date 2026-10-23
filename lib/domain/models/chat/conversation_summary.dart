import 'package:bidart/domain/models/chat/chat_message.dart';

class ConversationSummary {
  final String otherUserId;
  final ChatMessage lastMessage;

  const ConversationSummary({
    required this.otherUserId,
    required this.lastMessage,
  });
}
