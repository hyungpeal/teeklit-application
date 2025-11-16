import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_appbar_widget.dart';
import 'package:teeklit/ui/community/widgets/community_button_widgets.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/bookmark_toggle_button.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/comment_sort_toggle_buttons.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_comment_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_write_comment_section.dart';

class CommunityPostViewPage extends StatelessWidget {
  const CommunityPostViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        actions: [
          CustomIconButton(
            iconData: Icons.more_vert,
            callback: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.Bg,
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 카테고리, 북마크
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {GoRouter.of(context).goNamed('communityMain');},
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.DarkGreen,
                      minimumSize: Size(0, 0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Text(
                            '자유게시판',
                            style: TextStyle(
                              color: AppColors.Ivory,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: AppColors.Ivory,
                          ),
                        ],
                      ),
                    ),
                  ),
                  BookmarkToggleIconButton(),
                ],
              ),
              // 제목
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '집에서 안나가면 배달 시켜 드시나요?',
                  style: TextStyle(
                    color: AppColors.TxtLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // 이미지 닉네임 시간
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: EdgeInsets.only(right: 5),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://cdn.epnnews.com/news/photo/202008/5216_6301_1640.jpg',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '관악구치킨왕',
                        style: TextStyle(
                          color: AppColors.TxtLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.TxtLight,
                        ),
                        Text(
                          '2025.11.11',
                          style: TextStyle(
                            color: AppColors.TxtLight,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(
                color: AppColors.StrokeGrey,
              ),

              // 본문
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '저는 안나간지 좀 됐는데..혼자 살아서 밥을 어떻게 해먹어야 할지 모르겠어요. 저는 안나간지 좀 됐는데..혼자 살아서 밥을 어떻게 해먹어야 할지 모르겠어요. 저는 안나간지 좀 됐는데..혼자 살아서 밥을 어떻게 해먹어야 할지 모르겠어요.\n\n저는 안나간지 좀 됐는데..혼자 살아서 밥을 어떻게 해먹어야 할지 모르겠어요.',
                  style: TextStyle(
                    color: AppColors.TxtLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              // 좋아요 댓글
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Wrap(
                  spacing: 8,
                  children: [
                    CustomTextIconButton(
                      buttonText: Text(
                        '좋아요 4',
                        style: TextStyle(
                          color: AppColors.TxtLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      buttonIcon: Icon(
                        Icons.thumb_up_alt_outlined,
                        size: 12,
                        color: AppColors.TxtLight,
                      ),
                      boxColor: AppColors.RoundboxDarkBg,
                    ),
                    CustomTextIconButton(
                      buttonText: Text(
                        '댓글 3',
                        style: TextStyle(
                          color: AppColors.TxtLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      buttonIcon: Icon(
                        Icons.forum,
                        size: 12,
                        color: AppColors.TxtLight,
                      ),
                      boxColor: AppColors.RoundboxDarkBg,
                    ),
                  ],
                ),
              ),

              Divider(
                color: AppColors.StrokeGrey,
              ),

              // 댓글 개수, 댓글 정렬 토글버튼
              Row(
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

                  CommentSortToggleButtons(),
                ],
              ),

              ViewCommentSection(
                isRecomment: false,
                replies: [
                  ViewCommentSection(
                    isRecomment: true,
                  ),
                  ViewCommentSection(
                    isRecomment: true,
                  ),
                  ViewCommentSection(
                    isRecomment: true,
                  ),
                  ViewCommentSection(
                    isRecomment: true,
                  ),
                ],
              ),

              ViewCommentSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ViewWriteCommentSection(
        bottomPadding: bottomPadding,
      ),
    );
  }
}
