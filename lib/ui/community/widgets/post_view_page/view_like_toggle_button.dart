import 'package:flutter/material.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

class ViewLikeToggleButton extends StatefulWidget {
  final List<String> postLike;
  final Future<void> Function() tapLikeButton;
  final bool likeButtonSelected;

  const ViewLikeToggleButton({
    super.key,
    required this.postLike,
    required this.tapLikeButton,
    required this.likeButtonSelected,
  });

  @override
  State<ViewLikeToggleButton> createState() => _ViewLikeToggleButtonState();
}

class _ViewLikeToggleButtonState extends State<ViewLikeToggleButton> {

  late int likeCount = widget.postLike.length;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        if (widget.likeButtonSelected) {
          await widget.tapLikeButton();
          likeCount --;
        } else {
          await widget.tapLikeButton();
          likeCount ++;
        }
      },
      style: TextButton.styleFrom(
        minimumSize: Size(0, 0),
        backgroundColor: widget.likeButtonSelected
            ? AppColors.darkGreen
            : AppColors.roundboxDarkBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide.none,
        ),
        overlayColor: Colors.transparent,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(
        Icons.thumb_up_alt_outlined,
        size: 12,
        color: widget.likeButtonSelected ? AppColors.ivory : AppColors.txtLight,
      ),
      label: Text(
        '좋아요 $likeCount',
        style: TextStyle(
          color: widget.likeButtonSelected ? AppColors.ivory : AppColors.txtLight,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
