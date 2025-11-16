import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_button_widgets.dart';

/// 글쓰기 페이지 하단 미디어 버튼 BottomSheet
class PostMediaSection extends StatelessWidget {
  final double bottomPadding;

  const PostMediaSection({super.key, required this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.Bg,
        border: Border(top: BorderSide(color: AppColors.StrokeGrey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            children: [
              CustomTextIconButton(
                buttonText: Text(
                  '사진',
                  style: TextStyle(color: AppColors.TxtLight),
                ),
                buttonIcon: Icon(
                  Icons.photo,
                  color: AppColors.TxtLight,
                ),
              ),
              CustomTextIconButton(
                buttonText: Text(
                  '장소',
                  style: TextStyle(color: AppColors.TxtLight),
                ),
                buttonIcon: Icon(
                  Icons.place,
                  color: AppColors.TxtLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
