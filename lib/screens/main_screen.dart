import 'package:bidart/screens/chat/chat_list_screen.dart';
import 'package:bidart/screens/home.dart';
import 'package:bidart/screens/maps.dart';
import 'package:bidart/screens/people/people.dart';
import 'package:bidart/screens/profile.dart';
import 'package:bidart/screens/rooms/rooms.dart';
import 'package:bidart/widgets/bidart_app_bar.dart';
import 'package:bidart/widgets/navi_bar.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _indexSelected = 0;
  static const _titles = ["Bidart", "Rooms", "Map", "People", "Chats"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BidartAppBar(titles: _titles, indexSelected: _indexSelected),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.85,
        child: const Profile(),
      ),
      body: IndexedStack(
        index: _indexSelected,
        children: [
          const Home(),
          const Rooms(),
          const Maps(),
          const People(),
          ChatListScreen(
            onExplorePeople: () {
              setState(() {
                _indexSelected = 3;
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
