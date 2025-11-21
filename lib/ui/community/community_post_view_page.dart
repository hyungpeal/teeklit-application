import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_app_bar.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_body_post_content_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_footer_comment_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_header_buttons_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_header_post_info_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_write_comment_section.dart';

class CommunityPostViewPage extends StatelessWidget {
  const CommunityPostViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.Bg,
      resizeToAvoidBottomInset: true,
      appBar: ViewAppBar(),
      body: Padding(
        padding: EdgeInsets.only(bottom: 85),
        child: SingleChildScrollView(
          child: Container(
            color: AppColors.Bg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                // 카테고리, 북마크
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: ViewHeaderButtonsSection(),
                ),

                // 게시글 정보 -> 제목 이미지 닉네임 시간
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ViewHeaderPostInfoSection(),
                ),

                Divider(
                  color: AppColors.StrokeGrey,
                  indent: 15,
                  endIndent: 15,
                ),

                // 본문
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ViewBodyPostContentSection(),
                ),

                Divider(
                  color: AppColors.StrokeGrey,
                  indent: 15,
                  endIndent: 15,
                ),

                // 댓글창
                ViewFooterCommentSection(),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: ViewWriteCommentSection(
        bottomPadding: bottomPadding,
      ),
    );
  }
}
