import 'package:flutter/material.dart';

class RandomMoveCard extends StatelessWidget {
  final VoidCallback onPick;

  const RandomMoveCard({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '랜덤 무브로 상쾌한 아침 어때요?',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: onPick, child: const Text('뽑기'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3A3A3A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          )
        ],
      ),
    );
  }
}
