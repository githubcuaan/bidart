import 'package:flutter/material.dart';

class Navibar extends StatelessWidget {
  const Navibar({
    super.key,
    this._selectedIndex = 0,
    required this._onDestinationSelected,
  });

  final int _selectedIndex;
  final ValueChanged<int> _onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.create_outlined), label: 'Room'),
        NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
        NavigationDestination(
          icon: Icon(Icons.people_outlined),
          label: 'People',
        ),
      ],
    );
  }
}
