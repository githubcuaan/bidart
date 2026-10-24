import 'package:bidart/features/profile/provider/profile_providers.dart';
import 'package:bidart/screens/profile/history/match_history_screen.dart';
import 'package:bidart/screens/profile/rules/favorite_rules_screen.dart';
import 'package:bidart/screens/profile/settings/account_settings_screen.dart';
import 'package:bidart/data/repositories/in_memory_user_repository.dart';
import 'package:bidart/screens/profile/widgets/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:bidart/screens/profile/widgets/profile_edit_screen.dart';

typedef ProfileEdit = ProfileEditScreen;

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.findAncestorWidgetOfExactType<UncontrolledProviderScope>() == null) {
      return ProviderScope(
        overrides: [
          userRepositoryProvider.overrideWithValue(InMemoryUserRepository()),
        ],
        child: const _ProfileView(),
      );
    }
    return const _ProfileView();
  }
}

class _ProfileView extends ConsumerWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider);

    return userAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      ),
      error: (e, _) => Center(
        child: Text('Lỗi tải thông tin: $e'),
      ),
      data: (user) {
        final avatarLetter = user.name.trim().isNotEmpty
            ? user.name.trim().characters.first.toUpperCase()
            : '?';

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                          ? Text(
                              avatarLetter,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Chip(
                            label: Text('Hạng ${user.selfDeclaredLevel.name.toUpperCase()}'),
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${user.age} tuổi • ${user.gender}${user.address.isNotEmpty ? ' • ${user.address}' : ''}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Chỉnh sửa hồ sơ',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProfileEditScreen(currentUser: user),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatBox(value: '${user.totalMatches}', label: 'Tổng trận'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatBox(
                    value: '${user.winRate.toStringAsFixed(0)}%',
                    label: 'Thắng',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatBox(value: '${user.eloRating}', label: 'ELO'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.phone_outlined),
                    title: Text(
                      user.phone.isNotEmpty ? user.phone : 'Chưa cập nhật SĐT',
                    ),
                    dense: true,
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(
                      user.email.isNotEmpty ? user.email : 'Chưa cập nhật email',
                    ),
                    dense: true,
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(
                      user.address.isNotEmpty ? user.address : 'Chưa cập nhật địa chỉ',
                    ),
                    dense: true,
                  ),
                  ListTile(
                    leading: const Icon(Icons.military_tech_outlined),
                    title: Text(
                      'Hạng ${user.selfDeclaredLevel.name.toUpperCase()} (tự khai báo)',
                    ),
                    dense: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.history_outlined),
                    title: const Text('Lịch sử đấu'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const MatchHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bookmark_outline),
                    title: const Text('Bộ luật yêu thích'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const FavoriteRulesScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text('Quán đã lưu'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Cài đặt tài khoản'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AccountSettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}