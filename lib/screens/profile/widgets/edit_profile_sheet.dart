import 'package:bidart/core/enum/skill_level.dart';
import 'package:bidart/models/user.dart';
import 'package:flutter/material.dart';

class EditProfileSheet extends StatefulWidget {
  final User user;
  final ValueChanged<User> onSave;

  const EditProfileSheet({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late SkillLevel _selectedLevel;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _selectedLevel = widget.user.level;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chỉnh sửa thông tin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Họ và tên',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Số điện thoại',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<SkillLevel>(
            value: _selectedLevel,
            decoration: const InputDecoration(
              labelText: 'Hạng cơ thủ',
              border: OutlineInputBorder(),
            ),
            items: SkillLevel.values.map((lvl) {
              return DropdownMenuItem(
                value: lvl,
                child: Text('Hạng ${lvl.code} - ${lvl.displayName}'),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedLevel = val);
              }
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                final updated = widget.user.copyWith(
                  name: _nameController.text.trim(),
                  phone: _phoneController.text.trim(),
                  level: _selectedLevel,
                );
                widget.onSave(updated);
                Navigator.pop(context);
              },
              child: const Text('Lưu thay đổi'),
            ),
          ),
        ],
      ),
    );
  }
}
