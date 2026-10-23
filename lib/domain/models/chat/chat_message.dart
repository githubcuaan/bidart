class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime createdAt;
  final bool isInvitation;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.createdAt,
    this.isInvitation = false,
  });

  bool isFromMe(String currentUserId) => senderId == currentUserId;
}
