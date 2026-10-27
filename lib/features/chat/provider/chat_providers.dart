import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bidart/data/repositories/firestore_chat_repository.dart';
import 'package:bidart/data/repositories/in_memory_chat_repository.dart';
import 'package:bidart/domain/models/chat/chat_message.dart';
import 'package:bidart/domain/models/chat/conversation_summary.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/domain/repositories/chat_repository.dart';
import 'package:bidart/features/matchmaking/provider/matchmaking_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  if (Firebase.apps.isNotEmpty) {
    return FirestoreChatRepository();
  }
  return InMemoryChatRepository();
});

final chatMessagesStreamProvider =
    StreamProvider.family<List<ChatMessage>, String>((ref, opponentId) {
  final repo = ref.watch(chatRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  return repo.watchMessages(
    currentUserId: currentUserId,
    otherUserId: opponentId,
  );
});

final recentConversationsProvider =
    StreamProvider<List<ConversationSummary>>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  return repo.watchConversations(currentUserId);
});

class ChatController extends Notifier<void> {
  @override
  void build() {}

  Future<void> sendMessage({
    required String opponentId,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final repo = ref.read(chatRepositoryProvider);
    final currentUserId = ref.read(currentUserIdProvider);
    await repo.sendMessage(
      senderId: currentUserId,
      receiverId: opponentId,
      text: trimmed,
      isInvitation: false,
    );
  }

  Future<void> sendChallengeInvitation({
    required String opponentId,
    String? message,
  }) async {
    final repo = ref.read(chatRepositoryProvider);
    final currentUserId = ref.read(currentUserIdProvider);
    final text = message ??
        'Chào bạn, mình gửi lời mời thách đấu một trận bida giao lưu nhé! 🎱';

    await repo.sendMessage(
      senderId: currentUserId,
      receiverId: opponentId,
      text: text,
      isInvitation: true,
    );
  }
}

final chatControllerProvider =
    NotifierProvider<ChatController, void>(ChatController.new);

final otherUserFutureProvider =
    FutureProvider.family<User, String>((ref, userId) async {
  if (Firebase.apps.isNotEmpty) {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final map = doc.data()!;
        return User(
          id: doc.id,
          name: (map['name'] as String?)?.isNotEmpty == true ? map['name'] as String : 'Cơ thủ',
          phone: (map['phone'] as String?) ?? '',
          email: (map['email'] as String?) ?? '',
          avatarUrl: map['avatarUrl'] as String?,
          age: (map['age'] as num?)?.toInt() ?? 25,
          gender: (map['gender'] as String?) ?? 'Nam',
        );
      }
    } catch (_) {}
  }
  return User(id: userId, name: 'Đối thủ', phone: '');
});
