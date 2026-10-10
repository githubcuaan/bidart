import 'package:bidart/screens/home.dart';
import 'package:bidart/screens/maps.dart';
import 'package:bidart/screens/people.dart';
import 'package:bidart/screens/profile.dart';
import 'package:bidart/screens/rooms/rooms.dart';
import 'package:bidart/widgets/naviBar.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _indexSelected = 0;
  static const _titles = ["Bidart", "Rooms", "Map", "People", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_indexSelected])),
      body: IndexedStack(
        index: _indexSelected,
        children: [Home(), Rooms(), Maps(), People(), Profile()],
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
