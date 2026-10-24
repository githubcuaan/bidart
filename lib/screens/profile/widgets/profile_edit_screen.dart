import 'package:bidart/core/enum/skill_level.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/features/profile/provider/profile_providers.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileEditScreen extends StatefulWidget {
  final User? currentUser;

  const ProfileEditScreen({
    super.key,
    this.currentUser,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final User _baseUser;
  late final TextEditingController _name;
  late final TextEditingController _age;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late String _gender;
  late SkillLevel _level;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _baseUser = widget.currentUser ??
        const User(
          id: 'usr_tuananh',
          name: 'Tuấn Anh',
          phone: '0901 234 567',
          email: 'tuananh@example.com',
          age: 27,
          gender: 'Nam',
          address: 'Cầu Giấy, Hà Nội',
          selfDeclaredLevel: SkillLevel.b,
        );
    _name = TextEditingController(text: _baseUser.name);
    _age = TextEditingController(text: '${_baseUser.age}');
    _phone = TextEditingController(text: _baseUser.phone);
    _address = TextEditingController(text: _baseUser.address);
    _gender = _baseUser.gender;
    _level = _baseUser.selfDeclaredLevel;
  }

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

    final updated = _baseUser.copyWith(
      name: _name.text.trim(),
      age: int.tryParse(_age.text.trim()) ?? _baseUser.age,
      phone: _phone.text.trim(),
      address: _address.text.trim(),
      gender: _gender,
      selfDeclaredLevel: _level,
    );

    try {
      if (context.findAncestorWidgetOfExactType<UncontrolledProviderScope>() != null) {
        final container = ProviderScope.containerOf(context);
        await container.read(profileControllerProvider.notifier).updateProfile(updated);
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu thay đổi')),
    );
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
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Text(
                      _name.text.isNotEmpty
                          ? _name.text.trim().split(' ').last.substring(0, 1).toUpperCase()
                          : 'U',
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton.filledTonal(
                      tooltip: 'Đổi ảnh',
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chưa hỗ trợ chọn ảnh')),
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
