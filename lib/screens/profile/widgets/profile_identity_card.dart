import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/screens/profile/widgets/profile_edit_screen.dart';
import 'package:flutter/material.dart';

class ProfileIdentityCard extends StatelessWidget {
  final User user;

  const ProfileIdentityCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              child: Text(
                user.name.isNotEmpty
                    ? user.name.trim().split(' ').last.substring(0, 1).toUpperCase()
                    : 'U',
              ),
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
                    label: Text('Hạng ${user.selfDeclaredLevel.code}'),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user.age} tuổi • ${user.gender} • ${user.address.isNotEmpty ? user.address : 'Chưa cập nhật'}',
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
    );
  }
}
