import 'package:firebase_core/firebase_core.dart';
import 'package:bidart/data/repositories/firestore_matchmaking_repository.dart';
import 'package:bidart/data/repositories/in_memory_matchmaking_repository.dart';
import 'package:bidart/domain/models/matchmaking/matchmaking_filter.dart';
import 'package:bidart/domain/models/matchmaking/swipe_type.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/domain/repositories/matchmaking_repository.dart';
import 'package:bidart/features/auth/provider/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserIdProvider = Provider<String>((ref) {
  final authUser = ref.watch(authStateStreamProvider).value;
  return authUser?.id ?? ref.watch(authRepositoryProvider).currentUser?.id ?? 'usr_001';
});

final matchmakingRepositoryProvider = Provider<MatchmakingRepository>((ref) {
  if (Firebase.apps.isNotEmpty) {
    return FirestoreMatchmakingRepository();
  }
  return InMemoryMatchmakingRepository();
});

class MatchmakingFilterController extends Notifier<MatchmakingFilter> {
  @override
  MatchmakingFilter build() => const MatchmakingFilter();

  void updateDistance(double maxDistanceKm) {
    state = state.copyWith(maxDistanceKm: maxDistanceKm);
  }
}

final matchmakingFilterProvider =
    NotifierProvider<MatchmakingFilterController, MatchmakingFilter>(
  MatchmakingFilterController.new,
);

class MatchmakingFeedController extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    final repo = ref.watch(matchmakingRepositoryProvider);
    final uid = ref.watch(currentUserIdProvider);
    final filter = ref.watch(matchmakingFilterProvider);
    return repo.getCandidateCards(currentUserId: uid, filter: filter);
  }

  Future<void> swipe(User target, SwipeType type) async {
    final repo = ref.read(matchmakingRepositoryProvider);
    final uid = ref.read(currentUserIdProvider);
    await repo.recordSwipe(
      currentUserId: uid,
      targetUserId: target.id,
      swipeType: type,
    );
    final current = state.value ?? [];
    state = AsyncData(current.where((u) => u.id != target.id).toList());
  }

  Future<void> reload() async {
    final repo = ref.read(matchmakingRepositoryProvider);
    final uid = ref.read(currentUserIdProvider);
    await repo.resetSwipes(currentUserId: uid);
    ref.invalidateSelf();
  }
}

final matchmakingFeedProvider =
    AsyncNotifierProvider<MatchmakingFeedController, List<User>>(
  MatchmakingFeedController.new,
);
