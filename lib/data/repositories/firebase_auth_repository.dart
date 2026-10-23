import 'package:bidart/domain/models/auth/auth_user.dart';
import 'package:bidart/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb.FirebaseAuth? auth})
      : _auth = auth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  AuthUser _mapFirebaseUser(fb.User user) {
    return AuthUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName ?? (user.isAnonymous ? 'Khách' : user.email?.split('@').first),
      photoUrl: user.photoURL,
      isAnonymous: user.isAnonymous,
    );
  }

  @override
  Stream<AuthUser?> watchAuthState() {
    return _auth.authStateChanges().map(
          (user) => user == null ? null : _mapFirebaseUser(user),
        );
  }

  @override
  AuthUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : _mapFirebaseUser(user);
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
      }
      return _mapFirebaseUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  @override
  Future<AuthUser> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      return _mapFirebaseUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  void dispose() {}

  String _handleAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Mật khẩu hoặc email không chính xác';
      case 'email-already-in-use':
        return 'Email này đã được đăng ký tài khoản khác';
      case 'weak-password':
        return 'Mật khẩu quá yếu, vui lòng chọn mật khẩu mạnh hơn';
      case 'invalid-email':
        return 'Địa chỉ email không đúng định dạng';
      case 'too-many-requests':
        return 'Bạn đã thử đăng nhập quá nhiều lần. Vui lòng thử lại sau';
      default:
        return 'Lỗi xác thực: $code';
    }
  }
}