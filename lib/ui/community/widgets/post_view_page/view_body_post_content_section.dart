import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

class ViewBodyPostContentSection extends StatelessWidget {
  /// 게시글 상세보기 페이지의 몸통 section, 글 본문과 좋아요, 댓글 수 표시
  const ViewBodyPostContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}
