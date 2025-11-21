import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';

/// 커뮤니티 게시판의 카테고리 토글 버튼
class MainCategoryToggleButtons extends StatefulWidget {
  final List<String> categories;

  /// 카테고리 토글 버튼을 만드는 widget
  const MainCategoryToggleButtons({super.key, required this.categories});

  @override
  State<MainCategoryToggleButtons> createState() => _MainCategoryToggleButtonsState();
}

class _MainCategoryToggleButtonsState extends State<MainCategoryToggleButtons> {
  late List<bool> _selected;

  void updateButtonSeleccted(int i) {
    for (int j = 0; j < _selected.length; j++) {
      _selected[j] = j == i;
    }
  }

  @override
  void initState() {
    super.initState();
    _selected = List.generate(widget.categories.length, (_) => false);
    _selected[0] = true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double height = constraints.maxHeight;
        final String specificText = '인기';

        final List<Widget> buttonList = [];

        for (int i = 0; i < widget.categories.length; i++) {
          final String category = widget.categories[i];
          final bool isSelected = _selected[i];

          buttonList.add(
            Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.Green
                    : AppColors.RoundboxDarkBg,
                borderRadius: BorderRadius.circular(25),
              ),

              child: ToggleButtons(
                isSelected: [isSelected],
                onPressed: (index) {
                  setState(() {
                    updateButtonSeleccted(i);
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
                        if (category == specificText) ...[
                          Icon(
                            Icons.local_fire_department,
                            color: AppColors.WarningRed,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          category,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.Ivory : AppColors.TxtLight,
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

          if (category == specificText && i < widget.categories.length - 1) {
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