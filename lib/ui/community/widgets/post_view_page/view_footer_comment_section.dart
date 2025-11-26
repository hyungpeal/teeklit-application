import 'package:flutter/material.dart';
import 'package:teeklit/domain/model/community/comments.dart';
import 'package:teeklit/domain/model/user/user.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_footer_comment_contents_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_footer_comment_info_section.dart';

class ViewFooterCommentSection extends StatelessWidget {
  final List<(Comments, User)> parentComments;
  final Map<String, List<(Comments, User)>> childCommentsMap;
  final void Function(String) sortFunction;
  final Function(String?) onReply;
  final Future<void> Function() blockUser;
  final Future<bool> Function(String, String, String) reportPost;
  final Future<void> Function(String) hideComment;
  final String userId;
  final bool isAdmin;
  final int commentLength;

  /// 게시글 상세보기 페이지의 하단 댓글 section
  const ViewFooterCommentSection({
    super.key,
    required this.sortFunction,
    required this.onReply,
    required this.parentComments,
    required this.childCommentsMap,
    required this.blockUser,
    required this.reportPost,
    required this.hideComment,
    required this.userId,
    required this.isAdmin,
    required this.commentLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 댓글 개수, 댓글 정렬 토글버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ViewFooterCommentInfoSection(
            sortFunction: sortFunction,
            commentCount: commentLength,
          ),
        ),

        // 댓글 창
        if (parentComments.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: parentComments.length,
            itemBuilder: (context, index) {
              final (parentComment, parentUser) = parentComments[index];
              final String? parentId = parentComment.commentId;

              final myChildren = childCommentsMap[parentId] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ViewFooterCommentContentsSection(
                    commentInfo: parentComment,
                    userInfo: parentUser,
                    onReply: onReply,
                    blockUser: blockUser,
                    reportPost: reportPost,
                    hideComment: hideComment,
                    userId: userId,
                    isAdmin: isAdmin,
                  ),
                  ...myChildren.map((comment) {
                    return ViewFooterCommentContentsSection(
                      commentInfo: comment.$1,
                      userInfo: comment.$2,
                      onReply: onReply,
                      blockUser: blockUser,
                      reportPost: reportPost,
                      hideComment: hideComment,
                      userId: userId,
                      isAdmin: isAdmin,
                    );
                  }),
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}
