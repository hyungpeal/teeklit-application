import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teeklit/domain/model/community/posts.dart';
import 'package:teeklit/ui/community/view_model/community_view_model.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

/// 커뮤니티 게시판의 카테고리 토글 버튼
class MainCategoryToggleButtons extends StatefulWidget {
  final List<PostCategory> categories;

  /// 카테고리 토글 버튼을 만드는 widget
  const MainCategoryToggleButtons({super.key, required this.categories});

  @override
  State<MainCategoryToggleButtons> createState() => _MainCategoryToggleButtonsState();
}

class _MainCategoryToggleButtonsState extends State<MainCategoryToggleButtons> {
  late List<bool> _selected;

  void updateButtonSelected(int i) {
    for (int j = 0; j < _selected.length; j++) {
      _selected[j] = j == i;
    }
  }

  @override
  void initState() {
    super.initState();
    _selected = List.generate(widget.categories.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    PostCategory mainCategory = context.read<CommunityViewModel>().mainCategory;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double height = constraints.maxHeight;

        final List<Widget> buttonList = [];

        for (int i = 0; i < widget.categories.length; i++) {
          final String category = widget.categories[i].value;
          bool isSelected = _selected[i];

          if(category == mainCategory.value) {
            isSelected = true;
          }

          buttonList.add(
            Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.green
                    : AppColors.roundboxDarkBg,
                borderRadius: BorderRadius.circular(25),
              ),

              child: ToggleButtons(
                isSelected: [isSelected],
                onPressed: (index) async{
                  await context.read<CommunityViewModel>().changeCategory(widget.categories[i]);
                  setState(() {
                    updateButtonSelected(i);
                  });
                },
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                renderBorder: false,
                borderRadius: BorderRadius.circular(25),
                splashColor: Colors.transparent,
                constraints: BoxConstraints(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (category == PostCategory.popular.value) ...[
                          Icon(
                            Icons.local_fire_department,
                            color: AppColors.warningRed,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          category,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.ivory : AppColors.txtLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

          if (category == PostCategory.popular.value && i < widget.categories.length - 1) {
            buttonList.add(
              Container(
                width: 1.5,
                height: height * 0.5,
                color: AppColors.strokeGray,
              ),
            );
          }
        }

        return Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: buttonList,

        );
      },
    );
  }
}