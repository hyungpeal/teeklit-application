import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_comment_sort_toggle_buttons.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_footer_comment_contents_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_footer_comment_info_section.dart';

class ViewFooterCommentSection extends StatelessWidget {
  /// 게시글 상세보기 페이지의 하단 댓글 section
  const ViewFooterCommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 댓글 개수, 댓글 정렬 토글버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ViewFooterCommentInfoSection(),
        ),

        // 댓글 창
        ViewFooterCommentContentsSection(),
        ViewFooterCommentContentsSection(isRecomment: true,),
        ViewFooterCommentContentsSection(),
      ],
    );
  }
}
