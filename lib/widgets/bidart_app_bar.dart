import 'package:bidart/widgets/branding/bidart_logo.dart';
import 'package:bidart/widgets/theme_button.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bidart/features/profile/provider/profile_providers.dart';

/// Branded app bar shared by every tab: logo lockup on the left, theme,
/// notifications and the profile avatar on the right.
class BidartAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const BidartAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final profileState = ref.watch(userProfileStreamProvider);
    final user = profileState is AsyncData<User> ? profileState.value : null;
    final avatarUrl = user?.avatarUrl;
    final avatarLetter = user?.name.trim().isNotEmpty == true
        ? user!.name.trim().characters.first.toUpperCase()
        : 'U';

    return AppBar(
      titleSpacing: 16,
      title: const BidartLogo(),
      actions: [
        const ThemeButton(),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, size: 28),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lịch sử ghép kèo & Thông báo')),
                );
              },
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: scheme.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openEndDrawer(),
              child: Tooltip(
                message: 'Mở hồ sơ',
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl == null || avatarUrl.isEmpty
                      ? Text(
                          avatarLetter,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
