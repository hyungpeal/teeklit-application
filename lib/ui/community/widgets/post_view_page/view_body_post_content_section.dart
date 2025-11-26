import 'package:flutter/material.dart';
import 'package:teeklit/ui/community/widgets/post_view_page/view_like_toggle_button.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

class ViewBodyPostContentSection extends StatelessWidget {
  final String contents;
  final List<String> postLike;
  final int commentLength;
  final Future<void> Function() tapLikeButton;
  final bool likeButtonSelected;
  final List<String> imgUrls;

  /// 게시글 상세보기 페이지의 몸통 section, 글 본문과 좋아요, 댓글 수 표시
  const ViewBodyPostContentSection({
    super.key,
    required this.contents,
    required this.postLike,
    required this.commentLength,
    required this.tapLikeButton,
    required this.likeButtonSelected,
    required this.imgUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            contents,
            style: TextStyle(
              color: AppColors.txtLight,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),

        if (imgUrls.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: imgUrls.map((imgUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imgUrl,
                    width: 120,  // 트위터 느낌
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Wrap(
            spacing: 8,
            children: [
              ViewLikeToggleButton(
                tapLikeButton: tapLikeButton,
                likeButtonSelected: likeButtonSelected,
                postLike: postLike,
              ),
              CustomTextIconButton(
                buttonText: Text(
                  '댓글 $commentLength',
                  style: TextStyle(
                    color: AppColors.txtLight,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                buttonIcon: Icon(
                  Icons.forum,
                  size: 12,
                  color: AppColors.txtLight,
                ),
                boxColor: AppColors.roundboxDarkBg,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
