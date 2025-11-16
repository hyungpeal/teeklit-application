import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';

/// 상세보기 댓글 정렬 토글 버튼
class CommentSortToggleButtons extends StatefulWidget {
  const CommentSortToggleButtons({super.key});

  @override
  State<CommentSortToggleButtons> createState() => _CommentSortToggleButtonsState();
}

class _CommentSortToggleButtonsState extends State<CommentSortToggleButtons> {
  final List<String> options = ['과거순', '최신순'];
  String selected = '최신순';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: options.map((item) {
        final bool isSelected = selected == item;

        return TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size(0, 0),
            backgroundColor: isSelected
                ? AppColors.DarkGreen
                : AppColors.RoundboxDarkBg,
            foregroundColor: isSelected
                ? AppColors.Ivory
                : AppColors.InactiveTxtGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide.none,
            ),

            overlayColor: Colors.transparent,
          ),
          onPressed: () {
            setState(() {
              selected = item;
            });
          },
          child: Text(
            item,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        );
      }).toList(),
    );
  }
}
