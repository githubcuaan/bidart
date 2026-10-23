import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:flutter/material.dart';

class TinderCard extends StatelessWidget {
  final User user;
  final VoidCallback onChallenge;
  final VoidCallback onPass;

  const TinderCard({
    super.key,
    required this.user,
    required this.onChallenge,
    required this.onPass,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = user.avatarUrl ?? '';
    final scheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(user.id),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onChallenge();
        } else {
          onPass();
        }
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 30),
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.flash_on, color: scheme.onPrimary, size: 40),
            const SizedBox(width: 8),
            Text(
              'THÁCH ĐẤU',
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          color: scheme.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'BỎ QUA',
              style: TextStyle(
                color: scheme.onError,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.close, color: scheme.onError, size: 40),
          ],
        ),
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (avatar.isNotEmpty)
              Image.network(
                avatar,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildDefaultBackground(context),
              )
            else
              _buildDefaultBackground(context),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.55, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${user.name} • ${user.age}t',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Hạng ${user.selfDeclaredLevel.code}',
                          style: TextStyle(
                            color: scheme.onSecondaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${user.selfDeclaredLevel.displayName} • ${user.gender}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Thắng ${user.winRate.toInt()}% (ELO ${user.eloRating})',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (user.address.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.78),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.address,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultBackground(BuildContext context) {
    final colors = AppSemanticColors.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.currentTurnSurfaceDeep,
            colors.currentTurnSurface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: colors.currentTurnAvatar,
              child: Text(
                user.name.isNotEmpty
                    ? user.name.trim().split(' ').last.substring(0, 1).toUpperCase()
                    : 'P',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: colors.onCurrentTurn,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sports_esports_rounded,
                  size: 16,
                  color: colors.currentTurnSubtitle,
                ),
                const SizedBox(width: 6),
                Text(
                  'BIDART PLAYER',
                  style: TextStyle(
                    color: colors.currentTurnSubtitle,
                    letterSpacing: 2,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
