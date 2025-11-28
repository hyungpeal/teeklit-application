import 'package:flutter/material.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

/// 게시글 상세보기 페이지 하단 댓글 영역
class ViewWriteCommentSection extends StatefulWidget {
  final FocusNode focusNode;
  final String? parentId;
  final Future<void> Function(String, String?) vmCommentWrite;

  /// 게시글 상세보기 페이지의 bottom, 댓글을 작성하는 section
  const ViewWriteCommentSection({
    super.key,
    required this.focusNode,
    required this.parentId,
    required this.vmCommentWrite,
  });

  @override
  State<ViewWriteCommentSection> createState() =>
      ViewWriteCommentSectionState();
}

class ViewWriteCommentSectionState extends State<ViewWriteCommentSection> {
  final TextEditingController _commentController = TextEditingController();

  void writeComment() {
    widget.vmCommentWrite(_commentController.text, widget.parentId);
    _commentController.clear();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isReplying = widget.parentId != null;

    return Container(
      padding: EdgeInsets.only(
        bottom: 10,
        left: 15,
        right: 15,
        top: 10,
      ),
      color: Color(0xff242424),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(isReplying) ...[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                '↳ 답글 작성중...',
                style: TextStyle(color: AppColors.txtLight,),
              ),
            )
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    focusNode: widget.focusNode,
                    controller: _commentController,
                    maxLines: 1,
                    cursorColor: AppColors.txtLight,
                    decoration: InputDecoration(
                      hint: Text(
                        '댓글을 입력하세요...',
                        style: TextStyle(color: AppColors.txtLight),
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: AppColors.txtLight,
                    ),
                  ),
                ),
              ),
              CustomIconButton(
                buttonIcon: Icon(
                  Icons.forum,
                  color: AppColors.txtLight,
                  size: 24,
                ),
                callback: () {
                  FocusScope.of(context).unfocus();
                  writeComment();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
