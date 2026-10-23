import 'package:bidart/domain/models/matchmaking/swipe_type.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/features/chat/provider/chat_providers.dart';
import 'package:bidart/features/matchmaking/provider/matchmaking_providers.dart';
import 'package:bidart/screens/people/chat/chat_screen.dart';
import 'package:bidart/screens/people/widgets/action_buttons.dart';
import 'package:bidart/screens/people/widgets/empty_state.dart';
import 'package:bidart/screens/people/widgets/people_top_bar.dart';
import 'package:bidart/screens/people/widgets/tinder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class People extends ConsumerWidget {
  const People({super.key});

  void _onChallenge(BuildContext context, WidgetRef ref, User player) {
    ref.read(matchmakingFeedProvider.notifier).swipe(player, SwipeType.like);
    ref
        .read(chatControllerProvider.notifier)
        .sendChallengeInvitation(opponentId: player.id);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(opponent: player),
      ),
    );
  }

  void _onPass(BuildContext context, WidgetRef ref, User player) {
    ref.read(matchmakingFeedProvider.notifier).swipe(player, SwipeType.pass);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã bỏ qua ${player.name}'),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(matchmakingFeedProvider);

    return Column(
      children: [
        const PeopleTopBar(),
        Expanded(
          child: feedAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Lỗi tải danh sách: $err')),
            data: (candidates) {
              if (candidates.isEmpty) {
                return EmptyState(
                  onReload: () =>
                      ref.read(matchmakingFeedProvider.notifier).reload(),
                );
              }

              final currentTarget = candidates.first;

              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TinderCard(
                        user: currentTarget,
                        onChallenge: () =>
                            _onChallenge(context, ref, currentTarget),
                        onPass: () => _onPass(context, ref, currentTarget),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ActionButtons(
                    onPass: () => _onPass(context, ref, currentTarget),
                    onChallenge: () =>
                        _onChallenge(context, ref, currentTarget),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}