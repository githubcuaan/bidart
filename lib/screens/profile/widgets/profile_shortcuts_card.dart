import 'package:bidart/screens/profile/history/match_history_screen.dart';
import 'package:bidart/screens/profile/rules/favorite_rules_screen.dart';
import 'package:bidart/screens/profile/settings/account_settings_screen.dart';
import 'package:flutter/material.dart';

class ProfileShortcutsCard extends StatelessWidget {
  const ProfileShortcutsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
