import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO Sliver 공부해보기
    return AppBar(
      backgroundColor: AppColors.Bg,
      title: Text(
        '커뮤니티',
        style: TextStyle(
          color: AppColors.TxtLight,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        CustomIconButton(
          buttonIcon: Icon(
            Icons.notifications_none,
            size: 24,
            color: AppColors.Ivory,
          ),
          callback: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
