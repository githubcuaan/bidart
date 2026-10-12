import 'package:bidart/models/mockUser.dart';
import 'package:bidart/models/user.dart';
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
        content: Text('Đã gửi lời mời thách đấu tới ${opponent.name}!'),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_soccer_outlined, size: 70, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Đã hết đối thủ quanh khu vực của bạn!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loadOpponents,
              icon: const Icon(Icons.refresh),
              label: const Text('Tìm lại từ đầu'),
            ),
          ],
        ),
      );
    }

    final currentTarget = _opponents.first;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Dismissible(
              key: Key(currentTarget.id),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  _onChallenge(currentTarget);
                } else {
                  _onPass(currentTarget);
                }
              },
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 30),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.flash_on, color: Colors.white, size: 40),
                    SizedBox(width: 8),
                    Text(
                      'THÁCH ĐẤU',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 30),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'BỎ QUA',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.close, color: Colors.white, size: 40),
                  ],
                ),
              ),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      currentTarget.avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 100),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                          stops: [0.6, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  currentTarget.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber[700],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Hạng ${currentTarget.level.code}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Trình độ: ${currentTarget.level.displayName} • ${currentTarget.level.description}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: 'pass_btn',
                backgroundColor: Colors.white,
                onPressed: () => _onPass(currentTarget),
                child: const Icon(Icons.close, color: Colors.red, size: 30),
              ),
              FloatingActionButton.extended(
                heroTag: 'challenge_btn',
                backgroundColor: Colors.green,
                onPressed: () => _onChallenge(currentTarget),
                icon: const Icon(Icons.flash_on, color: Colors.white),
                label: const Text(
                  'Thách đấu',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
