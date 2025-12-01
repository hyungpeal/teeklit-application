import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teeklit/domain/model/community/posts.dart';
import 'package:teeklit/ui/community/view_model/community_view_model.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_bookmark_toggle_button.dart';

class ViewHeaderButtonsSection extends StatelessWidget {
  final String category;

  /// 게시글 상세보기 페이지의 상단에서 버튼이 있는 section
  const ViewHeaderButtonsSection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            // context.read<CommunityViewModel>().mainCategory = PostCategory.parse(category);
            context.go('/community/');
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColors.darkGreen,
            minimumSize: Size(0, 0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Text(
                  category,
                  style: TextStyle(
                    color: AppColors.ivory,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 10,
                  color: AppColors.ivory,
                ),
              ],
            ),
          ),
        ),
        /// TODO 북마크 아직 안함
        // ViewBookmarkToggleButton(),
      ],
    );
  }
}
