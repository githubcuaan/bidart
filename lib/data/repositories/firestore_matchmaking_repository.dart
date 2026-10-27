import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bidart/core/enum/skill_level.dart';
import 'package:bidart/domain/models/matchmaking/matchmaking_filter.dart';
import 'package:bidart/domain/models/matchmaking/swipe_type.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/domain/repositories/matchmaking_repository.dart';

class FirestoreMatchmakingRepository implements MatchmakingRepository {
  final FirebaseFirestore _firestore;

  FirestoreMatchmakingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> _swipesCol(String uid) =>
      _usersCol.doc(uid).collection('swipes');

  User _userFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
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

    return User(
      id: (map['id'] as String?)?.isNotEmpty == true ? map['id'] as String : doc.id,
      name: (map['name'] as String?)?.isNotEmpty == true ? map['name'] as String : 'Cơ thủ',
      phone: (map['phone'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      avatarUrl: map['avatarUrl'] as String?,
      description: (map['description'] as String?) ?? '',
      age: (map['age'] as num?)?.toInt() ?? 25,
      gender: (map['gender'] as String?) ?? 'Nam',
      address: (map['address'] as String?) ?? '',
      selfDeclaredLevel: map['selfDeclaredLevel'] != null
          ? SkillLevel.values.firstWhere(
              (e) => e.name.toLowerCase() == map['selfDeclaredLevel'].toString().toLowerCase(),
              orElse: () => SkillLevel.c,
            )
          : SkillLevel.c,
      totalMatches: (map['totalMatches'] as num?)?.toInt() ?? 0,
      winRate: (map['winRate'] as num?)?.toDouble() ?? 0.0,
      eloRating: (map['eloRating'] as num?)?.toInt() ?? 1500,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  @override
  Future<List<User>> getCandidateCards({
    required String currentUserId,
    MatchmakingFilter? filter,
  }) async {
    final swipesSnapshot = await _swipesCol(currentUserId).get();
    final swipedIds = swipesSnapshot.docs.map((d) => d.id).toSet();

    final usersSnapshot = await _usersCol.limit(50).get();

    final candidates = <User>[];
    for (final doc in usersSnapshot.docs) {
      if (doc.id == currentUserId) continue;
      if (swipedIds.contains(doc.id)) continue;
      candidates.add(_userFromDoc(doc));
    }

    return candidates;
  }

  @override
  Future<void> recordSwipe({
    required String currentUserId,
    required String targetUserId,
    required SwipeType swipeType,
  }) async {
    await _swipesCol(currentUserId).doc(targetUserId).set({
      'type': swipeType.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> resetSwipes({required String currentUserId}) async {
    final snapshot = await _swipesCol(currentUserId).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
