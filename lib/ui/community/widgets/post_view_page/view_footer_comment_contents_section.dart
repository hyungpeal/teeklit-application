import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/domain/model/community/comments.dart';
import 'package:teeklit/domain/model/community/report.dart';
import 'package:teeklit/domain/model/user/user.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

/// 게시글 상세보기 페이지 댓글창
class ViewFooterCommentContentsSection extends StatefulWidget {
  final Comments commentInfo;
  final User userInfo;
  final String userId;
  final bool isAdmin;
  final String myId;
  final Function(String?) onReply;
  final Future<void> Function() blockUser;
  final Future<bool> Function(String, String, String) reportPost;
  final Future<void> Function(String) hideComment;
  final Future<void> Function(String) deleteComment;

  /// 댓글 보여주는 위젯
  const ViewFooterCommentContentsSection({
    super.key,
    required this.commentInfo,
    required this.userInfo,
    required this.onReply,
    required this.blockUser,
    required this.reportPost,
    required this.hideComment,
    required this.userId,
    required this.isAdmin,
    required this.myId,
    required this.deleteComment,
  });

  @override
  State<ViewFooterCommentContentsSection> createState() =>
      _ViewFooterCommentContentsSectionState();
}

class _ViewFooterCommentContentsSectionState
    extends State<ViewFooterCommentContentsSection> {
  late final String commentId;

  @override
  void initState() {
    super.initState();

    if (widget.commentInfo.commentId != null) {
      commentId = widget.commentInfo.commentId!;
    } else {
      commentId = 'null';
    }
  }

  // modal 모달
  Future<void> _openModal() async {
    await showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      backgroundColor: AppColors.bg,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.txtGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: CustomTextButton(
                    buttonText: Text(
                      '신고',
                      style: TextStyle(
                        color: AppColors.ivory,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    callback: () async {
                      await widget.reportPost(
                        commentId,
                        TargetType.comment.value.toString(),
                        widget.userId,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.txtGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: CustomTextButton(
                    buttonText: Text(
                      '차단',
                      style: TextStyle(
                        color: AppColors.ivory,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    callback: () async {
                      await widget.blockUser();
                      Navigator.pop(context);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.go('/community/');
                      });
                    },
                  ),
                ),
                if (widget.isAdmin) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.txtGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    child: CustomTextButton(
                      buttonText: Text(
                        '숨기기',
                        style: TextStyle(
                          color: AppColors.ivory,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      callback: () async {
                        await widget.hideComment(commentId);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
                if (widget.commentInfo.userId == widget.myId) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.txtGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    child: CustomTextButton(
                      buttonText: Text(
                        '삭제',
                        style: TextStyle(
                          color: AppColors.ivory,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      callback: () async {
                        await widget.deleteComment(commentId);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.warningRed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: CustomTextButton(
                    buttonText: Text(
                      '취소',
                      style: TextStyle(
                        color: AppColors.ivory,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    callback: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 댓글 정보
  Widget _buildCommentInfo() {
    return Padding(
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
                  widget.userInfo.profileImagePath ??
                      'https://cdn.epnnews.com/news/photo/202008/5216_6301_1640.jpg',
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              widget.userInfo.nickname,
              style: TextStyle(
                color: AppColors.txtLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            spacing: 5,
            children: [
              Text(
                widget.commentInfo.createAt.toString(),
                style: TextStyle(
                  color: AppColors.inactiveTxtGray,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
              CustomIconButton(
                buttonIcon: Icon(
                  Icons.more_vert,
                  color: AppColors.txtGray,
                  size: 16,
                ),
                callback: _openModal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 댓글 내용
  Widget _buildCommentBody() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.fromSize(
          size: Size(30, 30),
        ),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.commentInfo.commentContents,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.txtLight,
                ),
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    // CustomTextIconButton( // TODO 여유 되면 댓글 좋아요 버튼 구현
                    //   buttonText: Text(
                    //     '${widget.commentInfo.commentLike?.length ?? 0}',
                    //     style: TextStyle(
                    //       color: AppColors.txtLight,
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 10,
                    //     ),
                    //   ),
                    //   buttonIcon: Icon(
                    //     Icons.thumb_up_alt_outlined,
                    //     size: 14,
                    //     color: AppColors.txtLight,
                    //   ),
                    //   callback: () {},
                    // ),
                    if (widget.commentInfo.parentId == null) ...[
                      TextButton(
                        onPressed: () {
                          widget.onReply(commentId);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '댓글달기',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.txtLight,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.commentInfo.parentId != null
            ? Color(0xff242424)
            : AppColors.bg,
        border:
            // widget.commentInfo.parentId != null
            //     ? Border(top: BorderSide(color: AppColors.strokeGray)) :
            Border(bottom: BorderSide(color: AppColors.strokeGray)),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: widget.commentInfo.parentId != null ? 45 : 15,
              right: 15,
            ),
            child: Column(
              children: [
                // 댓글 정보
                _buildCommentInfo(),
                // 댓글 내용, 좋아요와 댓글달기 버튼
                _buildCommentBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
