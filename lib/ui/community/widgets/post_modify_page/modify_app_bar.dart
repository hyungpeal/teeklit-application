import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

/// 커뮤니티 글 수정하기 Appbar
class ModifyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;

  /// 글 수정하기 페이지에서 사용하는 app bar
  const ModifyAppBar({super.key, required this.actions,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bg,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: Icon(Icons.chevron_left, color: AppColors.txtGray),
      ),
      actions: actions,
      shape: Border(bottom: BorderSide(color: AppColors.txtLight, width: 0.5)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

