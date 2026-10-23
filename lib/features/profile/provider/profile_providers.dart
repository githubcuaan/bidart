import 'package:bidart/data/repositories/in_memory_user_repository.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final repo = InMemoryUserRepository();
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