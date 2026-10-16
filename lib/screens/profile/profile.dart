import 'package:bidart/models/mockUser.dart';
import 'package:bidart/models/user.dart';
import 'package:bidart/screens/profile/widgets/edit_profile_sheet.dart';
import 'package:bidart/screens/profile/widgets/profile_header.dart';
import 'package:bidart/screens/profile/widgets/profile_info.dart';
import 'package:bidart/screens/profile/widgets/profile_menu.dart';
import 'package:bidart/screens/profile/widgets/skill_level_card.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = mockCurrentUser;
  }

  void _openEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => EditProfileSheet(
        user: _currentUser,
        onSave: (updated) {
          setState(() => _currentUser = updated);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật thông tin thành công!')),
          );
        },
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đăng xuất (Mock)!')),
              );
            },
            child: const Text('Đồng ý', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(avatarUrl: _currentUser.avatar),
            ProfileInfo(
              name: _currentUser.name,
              email: _currentUser.email,
              phone: _currentUser.phone,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SkillLevelCard(level: _currentUser.level),
                  const SizedBox(height: 14),
                  ProfileMenu(
                    onEditProfile: _openEditSheet,
                    onLogout: _confirmLogout,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
