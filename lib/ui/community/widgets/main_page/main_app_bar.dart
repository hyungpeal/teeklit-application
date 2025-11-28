import 'package:flutter/material.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bg,
      title: Text(
        '커뮤니티',
        style: TextStyle(
          color: AppColors.txtLight,
          fontWeight: FontWeight.bold,
        ),
      ),
      // actions: [
      //   CustomIconButton(
      //     buttonIcon: Icon(
      //       Icons.notifications_none,
      //       size: 24,
      //       color: AppColors.ivory,
      //     ),
      //     callback: () {},
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
