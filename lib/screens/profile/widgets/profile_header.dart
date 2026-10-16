import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String avatarUrl;

  const ProfileHeader({
    super.key,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E1A47), Color(0xFF6A0DAD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          bottom: -46,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: CircleAvatar(
                  radius: 46,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 15),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
