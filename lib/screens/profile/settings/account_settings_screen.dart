import 'package:bidart/core/theme/theme_mode_controller.dart';
import 'package:bidart/domain/models/user/user.dart';
import 'package:bidart/features/profile/provider/account_security_provider.dart';
import 'package:bidart/features/profile/provider/profile_providers.dart';
import 'package:bidart/screens/profile.dart';
import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  bool _notificationsEnabled = true;

  void _showChangePasswordDialog(BuildContext context) {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    String? errorText;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Đổi mật khẩu'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (errorText != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 18, color: Colors.red),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            errorText!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: currentPassController,
                  obscureText: obscureCurrent,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu hiện tại',
                    hintText: 'Mặc định: 123456',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCurrent
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () => setDialogState(
                          () => obscureCurrent = !obscureCurrent),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPassController,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu mới',
                    hintText: 'Ít nhất 6 ký tự',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () =>
                          setDialogState(() => obscureNew = !obscureNew),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPassController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu mới',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () => setDialogState(
                          () => obscureConfirm = !obscureConfirm),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                final cur = currentPassController.text;
                final nxt = newPassController.text;
                final cnf = confirmPassController.text;

                if (cur.isEmpty || nxt.isEmpty || cnf.isEmpty) {
                  setDialogState(() => errorText = 'Vui lòng điền đầy đủ thông tin');
                  return;
                }
                if (nxt.length < 6) {
                  setDialogState(
                      () => errorText = 'Mật khẩu mới phải có ít nhất 6 ký tự');
                  return;
                }
                if (nxt != cnf) {
                  setDialogState(
                      () => errorText = 'Mật khẩu xác nhận không trùng khớp');
                  return;
                }

                final success = ref
                    .read(accountSecurityProvider.notifier)
                    .changePassword(currentPassword: cur, newPassword: nxt);

                if (!success) {
                  setDialogState(
                      () => errorText = 'Mật khẩu hiện tại không chính xác');
                  return;
                }

                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đổi mật khẩu thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.orange.shade800),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã đăng xuất khỏi tài khoản'),
                ),
              );
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final passwordController = TextEditingController();
    bool obscure = true;
    String? errorText;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(
            'Xóa tài khoản vĩnh viễn',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hành động này không thể hoàn tác. Mọi thông tin hồ sơ, thống kê và điểm số ELO của bạn sẽ bị xóa vĩnh viễn.',
                  style: TextStyle(fontSize: 13.5, height: 1.4),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Vui lòng nhập mật khẩu tài khoản để xác minh:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (errorText != null) ...[
                  Text(
                    errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                ],
                TextField(
                  controller: passwordController,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    hintText: 'Mặc định: 123456',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () =>
                          setDialogState(() => obscure = !obscure),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final password = passwordController.text;
                if (password.isEmpty) {
                  setDialogState(
                      () => errorText = 'Vui lòng nhập mật khẩu để tiếp tục');
                  return;
                }

                final success = ref
                    .read(accountSecurityProvider.notifier)
                    .deleteAccount(password: password);

                if (!success) {
                  setDialogState(
                      () => errorText = 'Mật khẩu không chính xác. Vui lòng thử lại.');
                  return;
                }

                final defaultUser = User(
                  id: 'usr_guest',
                  name: 'Khách',
                  phone: '0000 000 000',
                  totalMatches: 0,
                  winRate: 0.0,
                  eloRating: 1000,
                );
                await ref.read(userRepositoryProvider).updateProfile(defaultUser);

                if (!context.mounted) return;
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tài khoản của bạn đã được xóa thành công!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Xác nhận xóa'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileStreamProvider);
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    final user = userAsync.asData?.value;
    final userName = user?.name ?? 'Tuấn Anh';
    final userEmail = user?.email.isNotEmpty == true
        ? user!.email
        : (user?.phone ?? '0901 234 567');

    return AppScreen(
      appBar: AppBar(
        title: const Text('Cài đặt tài khoản'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ProfileEdit(),
                        ),
                      );
                    },
                    child: const Text('Chỉnh sửa'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text(
              'BẢO MẬT & ĐĂNG NHẬP',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Đổi mật khẩu'),
                  subtitle: const Text('Cập nhật mật khẩu tài khoản'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showChangePasswordDialog(context),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Thông báo thách đấu'),
                  subtitle: const Text('Nhận thông báo khi có người mời đấu'),
                  value: _notificationsEnabled,
                  onChanged: (val) {
                    setState(() => _notificationsEnabled = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text(
              'GIAO DIỆN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Chế độ giao diện'),
              subtitle: Text(
                themeMode == ThemeMode.dark
                    ? 'Chế độ tối (Dark)'
                    : themeMode == ThemeMode.light
                        ? 'Chế độ sáng (Light)'
                        : 'Theo hệ thống',
              ),
              trailing: DropdownButton<ThemeMode>(
                value: themeMode,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('Hệ thống'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Sáng'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Tối'),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null) {
                    ref.read(themeModeProvider.notifier).setMode(mode);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text(
              'QUẢN LÝ TÀI KHOẢN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.red,
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.orange),
                  title: const Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () => _showLogoutDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Xóa tài khoản',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Yêu cầu xác minh mật khẩu để xóa vĩnh viễn'),
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
