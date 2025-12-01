import 'package:flutter/material.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/domain/model/enums.dart';

class TeekleListItem extends StatelessWidget {
  final String title;
  final String? tag;
  final Color color;
  final String? time;
  final TaskType? type;
  final String? youtubeUrl;
  final VoidCallback? onYoutubeTap;

  const TeekleListItem({
    super.key,
    required this.title,
    required this.tag,
    required this.color,
    required this.time,
    this.type,
    this.youtubeUrl,
    this.onYoutubeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              if (tag != null) ...[
                Chip(
                  label: Text(
                    tag!,
                    style: TextStyle(color: Colors.white),
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: AppColors.bg,
                ),
              ],
              const SizedBox(width: 8),
              if (time != null) ...[
                Icon(Icons.access_time, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Text(time!, style: const TextStyle(color: Colors.black54)),
              ],
              Spacer(),
              //For merge
              if (type == TaskType.workout && youtubeUrl != null) ...[
                GestureDetector(
                  onTap: () {
                    if (onYoutubeTap != null) {
                      onYoutubeTap!();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.link,
                      size: 20,
                      color: youtubeUrl != null ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
