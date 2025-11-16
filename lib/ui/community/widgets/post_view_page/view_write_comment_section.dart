import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_button_widgets.dart';

/// 게시글 상세보기 페이지 하단 댓글 영역
class ViewWriteCommentSection extends StatelessWidget {
  final double bottomPadding;

  const ViewWriteCommentSection({super.key, required this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        top: 10,
        left: 15,
        right: 15,
      ),
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
            iconData: Icons.forum,
            callback: () {},
          ),
        ],
      ),
    );
  }
}
