import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teeklit/ui/community/view_model/community_view_model.dart';
import 'package:teeklit/ui/community/view_model/report_view_model.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_app_bar.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_body_post_content_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_footer_comment_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_header_buttons_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_header_post_info_section.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_write_comment_section.dart';

class CommunityPostViewPage extends StatefulWidget {
  const CommunityPostViewPage({super.key});

  @override
  State<CommunityPostViewPage> createState() => _CommunityPostViewPageState();
}

class _CommunityPostViewPageState extends State<CommunityPostViewPage> {
  late FocusNode _inputFocusNode;
  String? _replyParentId;

  @override
  void initState() {
    super.initState();
    _inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _requestReplyComment(String? parentId) {
    _inputFocusNode.requestFocus();
    setState(() {
      _replyParentId = parentId;
    });
  }

  void _writeComplete() {
    _inputFocusNode.unfocus();
    setState(() {
      _replyParentId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CommunityViewModel>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xff242424),
        resizeToAvoidBottomInset: true,
        appBar: ViewAppBar(
          blockUser: vm.blockUser,
          reportPost: context.read<ReportViewModel>().submitReport,
          hidePost: vm.hidePost,
          postId: vm.postId,
          myId: vm.myId,
          postHost: vm.post.userId,
          isAdmin: vm.isAdmin,
          deletePost: vm.deletePost,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: AppColors.bg,
                    child: Consumer<CommunityViewModel>(
                      builder: (_, vm, _) {
                        if (vm.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // 카테고리, 북마크
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 5,
                              ),
                              child: ViewHeaderButtonsSection(
                                category: vm.post.category,
                              ),
                            ),
                            // 게시글 정보 -> 제목 이미지 닉네임 시간
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: ViewHeaderPostInfoSection(
                                title: vm.post.postTitle,
                                time: vm.post.createAt,
                                imgUrl: vm.postUserInfo.profileImagePath,
                                nickName: vm.postUserInfo.nickname,
                              ),
                            ),

                            Divider(
                              color: AppColors.strokeGray,
                              indent: 15,
                              endIndent: 15,
                            ),

                            // 본문
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: ViewBodyPostContentSection(
                                contents: vm.post.postContents,
                                postLike: vm.post.postLike,
                                commentLength: vm.commentList.length,
                                imgUrls: vm.post.imgUrls,
                                tapLikeButton: vm.tapLikeButton,
                                likeButtonSelected: vm.likeButtonIsSelected,
                              ),
                            ),

                            Divider(
                              color: AppColors.strokeGray,
                              indent: 15,
                              endIndent: 15,
                            ),

                            // 댓글창 TODO 댓글창만 따로 빼기 consumer 에서
                            ViewFooterCommentSection(
                              sortFunction: vm.commentSortByDate,
                              onReply: _requestReplyComment,
                              parentComments: vm.parentComments,
                              childCommentsMap: vm.childCommentsMap,
                              blockUser: vm.blockUser,
                              reportPost: context.read<ReportViewModel>().submitReport,
                              hideComment: vm.hideComment,
                              userId: vm.myId,
                              isAdmin: vm.isAdmin,
                              commentLength: vm.commentList.length,
                              myId: vm.myId,
                              deleteComment: vm.deleteComment,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              ViewWriteCommentSection(
                focusNode: _inputFocusNode,
                parentId: _replyParentId,
                vmCommentWrite: (content, parentId) async {
                  await context.read<CommunityViewModel>().commentWrite(
                    content,
                    parentId,
                  );
                  _writeComplete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
