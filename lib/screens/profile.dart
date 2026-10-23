import 'package:bidart/core/enum/skill_level.dart';
import 'package:bidart/screens/profile/history/match_history_screen.dart';
import 'package:bidart/screens/profile/rules/favorite_rules_screen.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';

/// Nội dung drawer phải (§5 docs/ui_description.md): 5.1 xem + 5.2 sửa.
class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 5.1.2 Card định danh
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(radius: 32, child: Text('TA')),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tuấn Anh',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Chip(
                        label: const Text('Hạng B+'),
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '27 tuổi • Nam • Cầu Giấy',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Chỉnh sửa hồ sơ',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileEdit()),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 5.1.3 Thống kê nhanh
        const Row(
          children: [
            Expanded(
              child: _StatBox(value: '142', label: 'Tổng trận'),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _StatBox(value: '68%', label: 'Thắng'),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _StatBox(value: '1680', label: 'ELO'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 5.1.4 Thông tin liên hệ
        const Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.phone_outlined),
                title: Text('0901 234 567'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.email_outlined),
                title: Text('tuananh@example.com'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.location_on_outlined),
                title: Text('Cầu Giấy, Hà Nội'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.military_tech_outlined),
                title: Text('Hạng B+ (tự khai báo)'),
                dense: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // 5.1.5 Lối tắt
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
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
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
              style: Theme.of(context).textTheme.headlineSmall
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

/// 5.2 Chỉnh sửa thông tin cá nhân (trang con push từ drawer).
class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: 'Tuấn Anh');
  final _age = TextEditingController(text: '27');
  final _phone = TextEditingController(text: '0901 234 567');
  final _address = TextEditingController(text: 'Cầu Giấy, Hà Nội');
  String _gender = 'Nam';
  SkillLevel _level = SkillLevel.b;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Đã lưu thay đổi')));
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      appBar: AppBar(title: const Text('Chỉnh sửa hồ sơ')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Đổi avatar
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(radius: 40, child: Text('TA')),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton.filledTonal(
                      tooltip: 'Đổi ảnh',
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text('Chưa hỗ trợ chọn ảnh'),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Tên hiển thị *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nhập tên' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _age,
                    decoration: const InputDecoration(labelText: 'Tuổi'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _gender,
                    decoration: const InputDecoration(labelText: 'Giới tính'),
                    items: const ['Nam', 'Nữ', 'Khác']
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (v) => setState(() => _gender = v ?? _gender),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                return RegExp(r'^[0-9+\s.]{9,}$').hasMatch(v.trim())
                    ? null
                    : 'SĐT chưa đúng';
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<SkillLevel>(
              initialValue: _level,
              decoration: const InputDecoration(
                labelText: 'Trình độ (tự khai báo)',
              ),
              items: SkillLevel.values
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text('${s.code} — ${s.displayName}'),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _level = v ?? _level),
            ),
            const SizedBox(height: 4),
            Text(
              _level.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Lưu thay đổi'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _saving ? null : () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
          ],
        ),
      ),
    );
  }
}
