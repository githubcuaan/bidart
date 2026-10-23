import 'package:bidart/domain/models/matchmaking/matchmaking_filter.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/domain/models/matchmaking/swipe_type.dart';

abstract interface class MatchmakingRepository {
  Future<List<User>> getCandidateCards({
    required String currentUserId,
    MatchmakingFilter? filter,
  });

  Future<void> recordSwipe({
    required String currentUserId,
    required String targetUserId,
    required SwipeType swipeType,
  });

  Future<void> resetSwipes({required String currentUserId});
}
