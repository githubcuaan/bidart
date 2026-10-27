import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bidart/domain/models/chat/chat_message.dart';
import 'package:bidart/domain/models/chat/conversation_summary.dart';
import 'package:bidart/domain/repositories/chat_repository.dart';

class FirestoreChatRepository implements ChatRepository {
  final FirebaseFirestore _firestore;

  FirestoreChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _convCol =>
      _firestore.collection('conversations');

  String _conversationKey(String a, String b) {
    final list = [a, b]..sort();
    return list.join('___');
  }

  ChatMessage _messageFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    final createdAtRaw = map['createdAt'];
    DateTime? createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw);
    } else if (createdAtRaw is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtRaw);
    }

    return ChatMessage(
      id: doc.id,
      senderId: (map['senderId'] as String?) ?? '',
      receiverId: (map['receiverId'] as String?) ?? '',
      text: (map['text'] as String?) ?? '',
      createdAt: createdAt ?? DateTime.now(),
      isInvitation: map['isInvitation'] == true,
    );
  }

  @override
  Future<List<ChatMessage>> getMessages({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final key = _conversationKey(currentUserId, otherUserId);
    final snapshot = await _convCol
        .doc(key)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs.map(_messageFromDoc).toList();
  }

  @override
  Future<ChatMessage> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
    bool isInvitation = false,
  }) async {
    final key = _conversationKey(senderId, receiverId);
    final now = DateTime.now();
    final convRef = _convCol.doc(key);
    final msgRef = convRef.collection('messages').doc();

    final messageData = {
      'id': msgRef.id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'createdAt': now.toIso8601String(),
      'isInvitation': isInvitation,
    };

    final batch = _firestore.batch();
    batch.set(msgRef, messageData);
    batch.set(
      convRef,
      {
        'id': key,
        'participants': [senderId, receiverId],
        'lastMessageId': msgRef.id,
        'lastMessageSenderId': senderId,
        'lastMessageReceiverId': receiverId,
        'lastMessageText': text,
        'lastMessageCreatedAt': now.toIso8601String(),
        'lastMessageIsInvitation': isInvitation,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();

    return ChatMessage(
      id: msgRef.id,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      createdAt: now,
      isInvitation: isInvitation,
    );
  }

  @override
  Stream<List<ChatMessage>> watchMessages({
    required String currentUserId,
    required String otherUserId,
  }) {
    final key = _conversationKey(currentUserId, otherUserId);
    return _convCol
        .doc(key)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_messageFromDoc).toList());
  }

  @override
  Stream<List<ConversationSummary>> watchConversations(String currentUserId) {
    return _convCol
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .map((snapshot) {
      final list = <ConversationSummary>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final participants = List<String>.from(data['participants'] ?? []);
        final otherId = participants.firstWhere(
          (id) => id != currentUserId,
          orElse: () => '',
        );
        if (otherId.isEmpty) continue;

        final rawDate = data['lastMessageCreatedAt'];
        DateTime? createdAt;
        if (rawDate is Timestamp) {
          createdAt = rawDate.toDate();
        } else if (rawDate is String) {
          createdAt = DateTime.tryParse(rawDate);
        }

        final lastMessage = ChatMessage(
          id: (data['lastMessageId'] as String?) ?? doc.id,
          senderId: (data['lastMessageSenderId'] as String?) ?? '',
          receiverId: (data['lastMessageReceiverId'] as String?) ?? '',
          text: (data['lastMessageText'] as String?) ?? '',
          createdAt: createdAt ?? DateTime.now(),
          isInvitation: data['lastMessageIsInvitation'] == true,
        );

        list.add(
          ConversationSummary(
            otherUserId: otherId,
            lastMessage: lastMessage,
          ),
        );
      }
      list.sort((a, b) => b.lastMessage.createdAt.compareTo(a.lastMessage.createdAt));
      return list;
    });
  }
}
