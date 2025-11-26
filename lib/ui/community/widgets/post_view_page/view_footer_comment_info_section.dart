import 'package:flutter/material.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_comment_sort_toggle_buttons.dart';

class ViewFooterCommentInfoSection extends StatelessWidget {
  final void Function(String) sortFunction;
  final int commentCount;

  /// 댓글 개수, 정렬 버튼 있는 section
  const ViewFooterCommentInfoSection({super.key, required this.sortFunction, required this.commentCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '댓글 $commentCount',
          style: TextStyle(
            color: AppColors.txtLight,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        ViewCommentSortToggleButtons(sortFunction: sortFunction,),
      ],
    );
  }
}
