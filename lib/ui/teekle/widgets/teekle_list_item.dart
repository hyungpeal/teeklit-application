import 'package:flutter/material.dart';

class MoveListItem extends StatelessWidget {
  final String title;
  final String tag;
  final Color color;
  final String time;

  const MoveListItem({super.key,
    required this.title,
    required this.tag,
    required this.color,
    required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              )),
          Row(
            children: [
              Chip(label: Text(tag),
                backgroundColor: Colors.black12,
              ),
              const SizedBox(width: 8),
              Icon(Icons.access_time, size: 16, color: Colors.black54),
              const SizedBox(width: 4),
              Text(time, style: const TextStyle(color: Colors.black54)),
            ],
          )
        ],
      ),
    );
  }
}
