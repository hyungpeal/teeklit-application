import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';

/// 커스텀 텍스트 아이콘 버튼
class CustomTextIconButton extends StatelessWidget {
  final Text buttonText;
  final Icon buttonIcon;
  final VoidCallback? callback;
  final Color? boxColor;

  const CustomTextIconButton({
    super.key,
    required this.buttonText,
    required this.buttonIcon,
    this.callback,
    this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: Colors.transparent,
        backgroundColor: boxColor ?? Colors.transparent,
        minimumSize: Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: buttonIcon,
      label: buttonText,
    );
  }
}

/// Text 형식의 버튼
class CustomTextButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? callback;

  const CustomTextButton({super.key, this.callback, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: callback,
      child: Text(buttonText, style: TextStyle(color: AppColors.TxtLight)),
    );
  }
}

/// Icon 형식의 버튼
class CustomIconButton extends StatelessWidget {
  final VoidCallback? callback;
  final IconData iconData;

  const CustomIconButton({super.key, this.callback, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: callback,
      icon: Icon(iconData, color: AppColors.Ivory),
    );
  }
}

