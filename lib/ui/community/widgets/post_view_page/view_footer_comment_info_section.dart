import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_comment_sort_toggle_buttons.dart';

class ViewFooterCommentInfoSection extends StatelessWidget {
  /// 댓글 개수, 정렬 버튼 있는 section
  const ViewFooterCommentInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '댓글 3',
          style: TextStyle(
            color: AppColors.TxtLight,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        ViewCommentSortToggleButtons(),
      ],
    );
  }
}
