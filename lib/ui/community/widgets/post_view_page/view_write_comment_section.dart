import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

/// 게시글 상세보기 페이지 하단 댓글 영역
class ViewWriteCommentSection extends StatelessWidget {
  final double bottomPadding;

  /// 게시글 상세보기 페이지의 bottom, 댓글을 작성하는 section
  const ViewWriteCommentSection({super.key, required this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    final double safePadding = viewInsets > 0 ? 0 : bottomPadding;

    return Container(
      padding: EdgeInsets.only(
        bottom: safePadding,
        top: 10,
        left: 15,
        right: 15,
      ),
      // bottom sheet가 body 부분을 침범하는 현상을 해결하기 위해 높이를 주고 이 높이만큼 body에 padding을 줌
      height: 85,
      color: Color(0xff242424),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.Bg,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                maxLines: 1,
                cursorColor: AppColors.TxtLight,
                decoration: InputDecoration(
                  hint: Text(
                    '댓글을 입력하세요...',
                    style: TextStyle(color: AppColors.TxtLight),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          CustomIconButton(
            buttonIcon: Icon(
              Icons.forum,
              color: AppColors.TxtLight,
              size: 24,
            ),
            callback: () {},
          ),
        ],
      ),
    );
  }
}
