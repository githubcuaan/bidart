import 'package:bidart/features/profile/provider/profile_providers.dart';
import 'package:bidart/screens/profile/widgets/profile_contact_card.dart';
import 'package:bidart/screens/profile/widgets/profile_identity_card.dart';
import 'package:bidart/screens/profile/widgets/profile_shortcuts_card.dart';
import 'package:bidart/screens/profile/widgets/profile_stat_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Lỗi tải hồ sơ: $err')),
      data: (user) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ProfileIdentityCard(user: user),
            const SizedBox(height: 12),
            ProfileStatRow(
              totalMatches: user.totalMatches,
              winRate: user.winRate,
              eloRating: user.eloRating,
            ),
            const SizedBox(height: 12),
            ProfileContactCard(user: user),
            const SizedBox(height: 12),
            const ProfileShortcutsCard(),
          ],
        );
      },
    );
  }
}
