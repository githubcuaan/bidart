import 'package:bidart/models/mockUser.dart';
import 'package:bidart/models/user.dart';
import 'package:bidart/screens/people/widgets/action_buttons.dart';
import 'package:bidart/screens/people/widgets/empty_state.dart';
import 'package:bidart/screens/people/widgets/people_top_bar.dart';
import 'package:bidart/screens/people/widgets/tinder_card.dart';
import 'package:flutter/material.dart';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  late List<User> _opponents;

  @override
  void initState() {
    super.initState();
    _loadOpponents();
  }

  void _loadOpponents() {
    setState(() {
      _opponents = List.from(mockOpponents);
    });
  }

  void _onChallenge(User opponent) {
    setState(() {
      _opponents.remove(opponent);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎯 Đã gửi lời mời thách đấu tới ${opponent.name}!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onPass(User opponent) {
    setState(() {
      _opponents.remove(opponent);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã bỏ qua ${opponent.name}'),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_opponents.isEmpty) {
      return Scaffold(
        body: Column(
          children: [
            const PeopleTopBar(),
            Expanded(
              child: EmptyState(onReload: _loadOpponents),
            ),
          ],
        ),
      );
    }

    final currentTarget = _opponents.first;

    return Scaffold(
      body: Column(
        children: [
          const PeopleTopBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TinderCard(
                user: currentTarget,
                onChallenge: () => _onChallenge(currentTarget),
                onPass: () => _onPass(currentTarget),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ActionButtons(
            onPass: () => _onPass(currentTarget),
            onChallenge: () => _onChallenge(currentTarget),
          ),
        ],
      ),
    );
  }
}