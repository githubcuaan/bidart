import 'package:bidart/widgets/theme_button.dart';
import 'package:flutter/material.dart';

class BidartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BidartAppBar({
    super.key,
    required this._titles,
    required this._indexSelected,
  });

  final List _titles;
  final int _indexSelected;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_titles[_indexSelected]),
      actions: [
        const ThemeButton(),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, size: 28),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lịch sử ghép kèo & Thông báo')),
                );
              },
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openEndDrawer(),
              child: const Tooltip(
                message: 'Mở hồ sơ',
                child: CircleAvatar(radius: 18, child: Text('TA')),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
