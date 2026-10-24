import 'package:flutter/material.dart';

import 'package:bidart/screens/chat/chat_list_screen.dart';
import 'package:bidart/screens/maps.dart';
import 'package:bidart/screens/people/people.dart';
import 'package:bidart/screens/profile.dart';
import 'package:bidart/screens/rooms/add_room/add_room.dart';
import 'package:bidart/screens/rooms/rooms.dart';
import 'package:bidart/widgets/bidart_app_bar.dart';
import 'package:bidart/widgets/navi_bar.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key, this.openCreateRoomOnStart = false});

  /// Used once after onboarding: pushes [AddRoom] on the first frame.
  final bool openCreateRoomOnStart;

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _indexSelected = 0;

  @override
  void initState() {
    super.initState();
    if (widget.openCreateRoomOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => const AddRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BidartAppBar(),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.85,
        child: const Profile(),
      ),
      body: IndexedStack(
        index: _indexSelected,
        children: [
          const Rooms(),
          const Maps(),
          const People(),
          ChatListScreen(
            onExplorePeople: () {
              setState(() {
                _indexSelected = 2;
              });
            },
          ),
        ],
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