import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';

/// 커뮤니티 게시판의 카테고리 토글 버튼
class CategoryToggleButtons extends StatefulWidget {
  final List<String> categories;

  const CategoryToggleButtons({super.key, required this.categories});

  @override
  State<CategoryToggleButtons> createState() => _CategoryToggleButtonsState();
}

class _CategoryToggleButtonsState extends State<CategoryToggleButtons> {
  late List<bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.generate(widget.categories.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double height = constraints.maxHeight;
        final String speText = '인기';

        final List<Widget> buttonList = [];

        for (int i = 0; i < widget.categories.length; i++) {
          final category = widget.categories[i];
          final isSelected = _selected[i];

          buttonList.add(
            Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.LightGreen
                    : AppColors.RoundboxDarkBg,
                borderRadius: BorderRadius.circular(25),
              ),
              // height: height * 0.6,

              child: ToggleButtons(
                isSelected: [isSelected],
                onPressed: (index) {
                  setState(() {
                    for (int j = 0; j < _selected.length; j++) {
                      _selected[j] = j == i;
                    }
                  });
                },
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                renderBorder: false,
                borderRadius: BorderRadius.circular(25),
                selectedBorderColor: AppColors.RoundboxDarkBg,
                fillColor: Colors.transparent,
                selectedColor: AppColors.Ivory,
                splashColor: Colors.transparent,
                constraints: BoxConstraints(
                  // minHeight: height*0.2, minWidth: 70
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (category == speText) ...[
                          Icon(
                            Icons.local_fire_department,
                            color: AppColors.WarningRed,
                            size: height * 0.2,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          category,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.TxtLight,
                            fontSize: height * 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

          if (category == speText && i < widget.categories.length - 1) {
            buttonList.add(
              Container(
                width: 1.5,
                height: height * 0.5,
                color: AppColors.StrokeGrey,
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