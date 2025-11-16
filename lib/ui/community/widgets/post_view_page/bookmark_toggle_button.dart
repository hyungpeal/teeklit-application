import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';

/// Icon을 누르면 색이 바뀌는 토글 버튼
class BookmarkToggleIconButton extends StatefulWidget {
  const BookmarkToggleIconButton({super.key});

  @override
  State<BookmarkToggleIconButton> createState() => _BookmarkToggleIconButtonState();
}

class _BookmarkToggleIconButtonState extends State<BookmarkToggleIconButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isSelected = !isSelected;
        });
      },

      icon: Icon(
        Icons.bookmark,
        size: 24,
        color: isSelected ? AppColors.DarkGreen : AppColors.Ivory,
      ),

      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}