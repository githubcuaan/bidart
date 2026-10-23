import 'package:bidart/domain/models/matchmaking/swipe_type.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/features/chat/provider/chat_providers.dart';
import 'package:bidart/features/matchmaking/provider/matchmaking_providers.dart';
import 'package:bidart/screens/people/chat/chat_screen.dart';
import 'package:bidart/screens/people/widgets/action_buttons.dart';
import 'package:bidart/screens/people/widgets/empty_state.dart';
import 'package:bidart/screens/people/widgets/filter_modal.dart';
import 'package:bidart/screens/people/widgets/tinder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class People extends ConsumerWidget {
  const People({super.key});

  void _openFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterModal(),
    );
  }

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

    return Stack(
      children: [
        Positioned.fill(
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
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
        Positioned(
          top: 24,
          right: 28,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openFilter(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}