import 'package:bidart/domain/models/chat/chat_message.dart';
import 'package:bidart/screens/rooms/add_room/add_room.dart';
import 'package:flutter/material.dart';

class ChallengeInvitationCard extends StatelessWidget {
  final ChatMessage message;
  final bool isFromMe;

  const ChallengeInvitationCard({
    super.key,
    required this.message,
    required this.isFromMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isFromMe
                ? [Colors.deepPurple.shade700, Colors.deepPurple.shade900]
                : [Colors.grey.shade800, Colors.grey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isFromMe
                ? Colors.purpleAccent.withValues(alpha: 0.4)
                : Colors.white24,
            width: 1.2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flash_on,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'KÈO THÁCH ĐẤU',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Tạo phòng đấu ngay',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AddRoom(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
