import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_bookmark_toggle_button.dart';

class ViewHeaderButtonsSection extends StatelessWidget {
  /// 게시글 상세보기 페이지의 상단에서 버튼이 있는 section
  const ViewHeaderButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  Icons.chevron_right,
                  size: 10,
                  color: AppColors.Ivory,
                ),
              ],
            ),
          ),
        ),
        ViewBookmarkToggleButton(),
      ],
    );
  }
}
