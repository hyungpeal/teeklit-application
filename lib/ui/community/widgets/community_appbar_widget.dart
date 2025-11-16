import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/config/colors.dart';

/// 커뮤니티 appBar Action에 어떤 버튼이 들어갈지 정하는 enum type
// enum AppBarActionType {write, setting, notification}

/// 커뮤니티 상단 Appbar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;

  const CustomAppBar({super.key, required this.actions,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.Bg,
      leading: IconButton(
        onPressed: () {GoRouter.of(context).pop();},
        icon: Icon(Icons.arrow_back_ios, color: AppColors.TxtGrey),
      ),
      actions: actions,
      shape: Border(bottom: BorderSide(color: AppColors.TxtLight, width: 0.5)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

