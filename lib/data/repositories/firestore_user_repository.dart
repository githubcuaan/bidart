import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bidart/core/enum/skill_level.dart';
import 'package:bidart/domain/models/auth/auth_user.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/domain/repositories/user_repository.dart';

class FirestoreUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;
  final AuthUser Function() getCurrentAuthUser;

  FirestoreUserRepository({
    FirebaseFirestore? firestore,
    required this.getCurrentAuthUser,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  User _defaultFromAuth(AuthUser auth) {
    return User(
      id: auth.id,
      name: auth.displayName?.isNotEmpty == true
          ? auth.displayName!
          : (auth.email?.split('@').first ?? 'Cơ thủ'),
      email: auth.email ?? '',
      phone: '',
      avatarUrl: auth.photoUrl,
      age: 25,
      gender: 'Nam',
      address: '',
      selfDeclaredLevel: SkillLevel.c,
      totalMatches: 0,
      winRate: 0.0,
      eloRating: 1500,
      createdAt: DateTime.now(),
    );
  }

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
  Future<User> getCurrentUser() async {
    final auth = getCurrentAuthUser();
    final doc = await _usersCol.doc(auth.id).get();

    if (doc.exists && doc.data() != null) {
      return _userFromDoc(doc);
    }

    final newUser = _defaultFromAuth(auth);
    await _usersCol.doc(auth.id).set(newUser.toJson());
    return newUser;
  }

  @override
  Future<void> updateProfile(User user) async {
    await _usersCol.doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }

  @override
  Stream<User> watchCurrentUser() {
    final auth = getCurrentAuthUser();
    return _usersCol.doc(auth.id).snapshots().asyncMap((doc) async {
      if (doc.exists && doc.data() != null) {
        return _userFromDoc(doc);
      }
      final defaultUser = _defaultFromAuth(auth);
      await _usersCol.doc(auth.id).set(defaultUser.toJson());
      return defaultUser;
    });
  }
}
