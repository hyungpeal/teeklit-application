import 'package:flutter/material.dart';

/// 커스텀 텍스트 아이콘 버튼
class CustomTextIconButton extends StatelessWidget {
  final Text buttonText;
  final Icon buttonIcon;
  final VoidCallback? callback;
  final Color? boxColor;

  /// text + icon을 조합하는 버튼을 사용하고 싶을 때 사용하는 위젯
  ///
  /// defualt -> icon + text, 반대로 사용하고 싶을 땐 text button 생성 후, child row에 text, icon 순으로 배치
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
      onPressed: callback,
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
  final Text buttonText;
  final VoidCallback? callback;

  /// text 형식의 버튼을 custom 해서 사용
  const CustomTextButton({super.key, this.callback, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: callback,
      style: TextButton.styleFrom(
        overlayColor: Colors.transparent,
      ),
      child: buttonText,
    );
  }
}

/// Icon 형식의 버튼
class CustomIconButton extends StatelessWidget {
  final VoidCallback? callback;
  final Icon buttonIcon;

  const CustomIconButton({super.key, this.callback, required this.buttonIcon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: callback,
      icon: buttonIcon,
      style: IconButton.styleFrom(
        minimumSize: Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
