import 'package:bidart/domain/models/user/user.dart';
import 'package:flutter/material.dart';

class ProfileContactCard extends StatelessWidget {
  final User user;

  const ProfileContactCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: Text(user.phone.isNotEmpty ? user.phone : 'Chưa có SĐT'),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(user.email.isNotEmpty ? user.email : 'Chưa có email'),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(user.address.isNotEmpty ? user.address : 'Chưa có địa chỉ'),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.military_tech_outlined),
            title: Text('Hạng ${user.selfDeclaredLevel.code} (${user.selfDeclaredLevel.displayName})'),
            dense: true,
          ),
        ],
      ),
    );
  }
}
