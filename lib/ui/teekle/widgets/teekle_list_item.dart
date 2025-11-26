import 'package:flutter/material.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

class TeekleListItem extends StatelessWidget {
  final String title;
  final String? tag;
  final Color color;
  final String? time;

  const TeekleListItem({
    super.key,
    required this.title,
    required this.tag,
    required this.color,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              if(tag != null) ... [
                Chip(label: Text(tag!, style: TextStyle(color: Colors.white),), backgroundColor: AppColors.bg),
              ],
              const SizedBox(width: 8),
              if(time != null) ... [
                Icon(Icons.access_time, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Text(time!, style: const TextStyle(color: Colors.black54)),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
