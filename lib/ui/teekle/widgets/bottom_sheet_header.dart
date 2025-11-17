import 'package:flutter/material.dart';

class TeekleBottomSheetHeader extends StatelessWidget {
  final String title;

  // 닫기 버튼(X)은 항상 필요!!!ㄱ
  final VoidCallback onClose;

  final bool showLeading;
  final VoidCallback? onLeadingTap;

  final bool showEdit;
  final VoidCallback? onEditTap;

  const TeekleBottomSheetHeader({
    super.key,
    required this.title,
    required this.onClose,
    this.showLeading = false,
    this.onLeadingTap,
    this.showEdit = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          children: [
            if (showLeading)
              GestureDetector(
                onTap: onLeadingTap,
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          children: [
            if (showEdit)
              GestureDetector(
                onTap: onEditTap,
                child: Row(
                  children: const [
                    Text(
                      '편집',
                      style: TextStyle(
                        color: Color(0xff8E8E93),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.mode_edit_outlined,
                      size: 14,
                      color: Color(0xff8E8E93),
                    ),
                  ],
                ),
              ),

            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: onClose,
            ),
          ],
        ),
      ],
    );
  }
}
