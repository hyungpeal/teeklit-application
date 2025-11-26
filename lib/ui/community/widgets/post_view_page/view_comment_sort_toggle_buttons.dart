import 'package:flutter/material.dart';
import 'package:teeklit/domain/model/community/comments.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

/// 상세보기 댓글 정렬 토글 버튼
class ViewCommentSortToggleButtons extends StatefulWidget {
  final void Function(String) sortFunction;

  const ViewCommentSortToggleButtons({super.key, required this.sortFunction});

  @override
  State<ViewCommentSortToggleButtons> createState() => _ViewCommentSortToggleButtonsState();
}

class _ViewCommentSortToggleButtonsState extends State<ViewCommentSortToggleButtons> {
  final List<String> options = [SortStandard.old.value, SortStandard.recent.value];
  String selected = SortStandard.old.value;

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
                ? AppColors.darkGreen
                : AppColors.roundboxDarkBg,
            foregroundColor: isSelected
                ? AppColors.ivory
                : AppColors.inactiveTxtGray,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide.none,
            ),

            overlayColor: Colors.transparent,
          ),
          onPressed: () {
            setState(() {
              selected = item;
              widget.sortFunction(item);
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
