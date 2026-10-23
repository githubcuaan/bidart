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
          color: Colors.green.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Icon(Icons.flash_on, color: Colors.white, size: 40),
            SizedBox(width: 8),
            Text(
              'THÁCH ĐẤU',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'BỎ QUA',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.close, color: Colors.white, size: 40),
          ],
        ),
      ),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (avatar.isNotEmpty)
              Image.network(
                avatar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildDefaultBackground(),
              )
            else
              _buildDefaultBackground(),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber[700],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Hạng ${user.selfDeclaredLevel.code}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        'Thắng ${user.winRate.toInt()}% (ELO ${user.eloRating})',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  if (user.address.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          user.address,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
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

  Widget _buildDefaultBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E1A47), Color(0xFF6A0DAD)],
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
              backgroundColor: Colors.white12,
              child: Text(
                user.name.isNotEmpty
                    ? user.name.trim().split(' ').last.substring(0, 1).toUpperCase()
                    : 'P',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '🎱 BIDART PLAYER',
              style: TextStyle(
                color: Colors.white54,
                letterSpacing: 2,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
