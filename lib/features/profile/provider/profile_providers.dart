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

class ProfileController extends StateNotifier<AsyncValue<void>> {
  ProfileController({required this.repository}) : super(const AsyncValue.data(null));

  final UserRepository repository;

  Future<bool> updateProfile(User user) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateProfile(user);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<void>>((ref) {
  return ProfileController(repository: ref.watch(userRepositoryProvider));
});