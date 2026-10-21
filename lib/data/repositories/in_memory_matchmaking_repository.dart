import 'package:bidart/domain/models/matchmaking/matchmaking_filter.dart';
import 'package:bidart/domain/models/matchmaking/swipe_type.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/domain/repositories/matchmaking_repository.dart';
import 'package:bidart/models/mockUser.dart';

class InMemoryMatchmakingRepository implements MatchmakingRepository {
  final Map<String, Set<String>> _swipedUserIds = {};

  @override
  Future<List<User>> getCandidateCards({
    required String currentUserId,
    MatchmakingFilter? filter,
  }) async {
    final swiped = _swipedUserIds[currentUserId] ?? {};

    return mockOpponents.where((user) {
      if (user.id == currentUserId) return false;
      if (swiped.contains(user.id)) return false;
      return true;
    }).toList();
  }

  @override
  Future<void> recordSwipe({
    required String currentUserId,
    required String targetUserId,
    required SwipeType swipeType,
  }) async {
    _swipedUserIds.putIfAbsent(currentUserId, () => {}).add(targetUserId);
  }

  @override
  Future<void> resetSwipes({required String currentUserId}) async {
    _swipedUserIds[currentUserId]?.clear();
  }
}
