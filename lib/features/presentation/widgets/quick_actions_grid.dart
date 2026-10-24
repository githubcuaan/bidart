import 'package:flutter/material.dart';

class QuickActionsGrid extends StatelessWidget {
  final VoidCallback onCreateRoom;
  final VoidCallback onJoinRoom;
  final VoidCallback onFindMatch;
  final VoidCallback onFindClubs;

  const QuickActionsGrid({
    super.key,
    required this.onCreateRoom,
    required this.onJoinRoom,
    required this.onFindMatch,
    required this.onFindClubs,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        title: 'Tạo phòng',
        subtitle: 'Tạo bàn bida mới',
        icon: Icons.add_circle_outline_rounded,
        colors: [const Color(0xFF0284C7), const Color(0xFF0369A1)],
        iconColor: const Color(0xFF38BDF8),
        onTap: onCreateRoom,
      ),
      _ActionItem(
        title: 'Vào phòng',
        subtitle: 'Nhập mã bàn chơi',
        icon: Icons.meeting_room_rounded,
        colors: [const Color(0xFF059669), const Color(0xFF047857)],
        iconColor: const Color(0xFF34D399),
        onTap: onJoinRoom,
      ),
      _ActionItem(
        title: 'Tìm đối thủ',
        subtitle: 'Ghép trận quanh bạn',
        icon: Icons.sports_kabaddi_rounded,
        colors: [const Color(0xFFD97706), const Color(0xFFB45309)],
        iconColor: const Color(0xFFFBBF24),
        onTap: onFindMatch,
      ),
      _ActionItem(
        title: 'Bản đồ CLB',
        subtitle: 'CLB Bida gần bạn',
        icon: Icons.map_rounded,
        colors: [const Color(0xFF7C3AED), const Color(0xFF6D28D9)],
        iconColor: const Color(0xFFA78BFA),
        onTap: onFindClubs,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final item = actions[index];
        return InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: item.colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: item.colors.last.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, size: 26, color: item.iconColor),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final Color iconColor;
  final VoidCallback onTap;

  _ActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.iconColor,
    required this.onTap,
  });
}