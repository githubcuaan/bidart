import 'package:firebase_core/firebase_core.dart';
import 'package:bidart/data/repositories/firestore_user_repository.dart';
import 'package:bidart/data/repositories/in_memory_user_repository.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bidart/features/auth/provider/auth_providers.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final authUser = ref.watch(authStateStreamProvider).value ?? ref.watch(authRepositoryProvider).currentUser;

  if (Firebase.apps.isNotEmpty && authUser != null) {
    return FirestoreUserRepository(
      getCurrentAuthUser: () =>
          ref.watch(authStateStreamProvider).value ??
          ref.watch(authRepositoryProvider).currentUser ??
          authUser,
    );
  }

  final initialUser = User(
    id: authUser?.id ?? 'guest_user',
    name: authUser?.displayName ?? (authUser?.email?.split('@').first ?? 'Cơ thủ'),
    email: authUser?.email ?? '',
    phone: '',
    address: '',
    age: 22,
    gender: 'Nam',
    totalMatches: 0,
    winRate: 0.0,
    eloRating: 1500,
    createdAt: DateTime.now(),
  );

  final repo = InMemoryUserRepository(initialUser: initialUser);
  ref.onDispose(repo.dispose);
  return repo;
});

final userProfileStreamProvider = StreamProvider<User>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.watchCurrentUser();
});

class ProfileController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> updateProfile(User user) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.updateProfile(user);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, AsyncValue<void>>(
  ProfileController.new,
);