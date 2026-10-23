import 'package:bidart/screens/home.dart';
import 'package:bidart/screens/maps.dart';
import 'package:bidart/screens/people/people.dart';
import 'package:bidart/screens/profile.dart';
import 'package:bidart/screens/rooms/rooms.dart';
import 'package:bidart/widgets/navi_bar.dart';
import 'package:bidart/widgets/theme_button.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _indexSelected = 0;
  static const _titles = ["Bidart", "Rooms", "Map", "People"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_indexSelected == 3)
          ? null
          : AppBar(
        title: Text(_titles[_indexSelected]),
        actions: [
          const ThemeButton(),
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
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.85,
        child: const Profile(),
      ),
      body: IndexedStack(
        index: _indexSelected,
        children: [Home(), Rooms(), Maps(), People()],
      ),
      bottomNavigationBar: Navibar(
        selectedIndex: _indexSelected,
        onDestinationSelected: (index) {
          setState(() {
            _indexSelected = index;
          });
        },
      ),
    );
  }
}
