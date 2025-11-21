import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/config/colors.dart';

/// 커뮤니티 글쓰기 버튼
class PostWriteButton extends StatelessWidget {
  const PostWriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        GoRouter.of(context).push('/community/write');
      },
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(15),
        backgroundColor: AppColors.Green,
      ),
      child: Icon(Icons.edit, color: AppColors.Ivory),
    );
  }
}