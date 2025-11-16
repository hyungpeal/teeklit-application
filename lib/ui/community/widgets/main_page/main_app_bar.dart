import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_button_widgets.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
        CustomIconButton(iconData: Icons.notifications, callback: (){},),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
