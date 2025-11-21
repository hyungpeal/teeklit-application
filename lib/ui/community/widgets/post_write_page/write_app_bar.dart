import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/config/colors.dart';

/// 커뮤니티 글쓰기 Appbar
class WriteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;

  /// 글쓰기 페이지에서 사용하는 app bar
  const WriteAppBar({super.key, required this.actions,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.Bg,
      leading: IconButton(
        onPressed: () {GoRouter.of(context).pop();},
        icon: Icon(Icons.chevron_left, color: AppColors.TxtGrey),
      ),
      actions: actions,
      shape: Border(bottom: BorderSide(color: AppColors.TxtLight, width: 0.5)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

