import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String day;
  final int doneCount;
  final int totalCount;
  final double progress;

  const ProgressCard({super.key,
    required this.day,
    required this.doneCount,
    required this.totalCount,
    required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Paperlogy',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A3A3A),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '공유하러 가기',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ))
                ],
              )),
          const SizedBox(width: 16),
          TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, _) {
                return SizedBox(
                  width: 70,
                  height: 70,
                  child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 6,
                            backgroundColor: const Color(0xFF3B3B3B),
                            valueColor: const AlwaysStoppedAnimation(Color(
                                0xFFE9A5B5)),
                          ),
                        ),
                        Text(
                          '$doneCount/$totalCount',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ]
                  ),
                );
              })
        ],
      ),
    );
  }
}
