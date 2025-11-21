import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

/// 글쓰기 페이지 하단 미디어 버튼 BottomSheet
class WriteMediaSection extends StatelessWidget {
  final double bottomPadding;
  final VoidCallback onPickImages;
  final List<XFile> images;
  final Function(XFile) onRemoveImage;

  /// 글쓰기 페이지 하단에 미디어 버튼을 고정시켜 배치함.
  const WriteMediaSection({
    super.key,
    required this.bottomPadding,
    required this.onPickImages,
    required this.images,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final double safePadding = viewInsets > 0 ? 0 : bottomPadding;

    return Container(
      padding: EdgeInsets.only(bottom: safePadding),
      decoration: BoxDecoration(
        color: AppColors.Bg,
        border: Border(top: BorderSide(color: AppColors.StrokeGrey)),
      ),
      height: 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (images.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: images.map((img) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(img.path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => onRemoveImage(img),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black54,
                            child: Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            Divider(color: AppColors.StrokeGrey,),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  CustomTextIconButton(
                    buttonText: Text(
                      '사진',
                      style: TextStyle(
                        color: AppColors.TxtLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    buttonIcon: Icon(
                      Icons.photo,
                      color: AppColors.TxtLight,
                    ),
                    callback: onPickImages,
                  ),
                  CustomTextIconButton(
                    buttonText: Text(
                      '장소',
                      style: TextStyle(
                        color: AppColors.TxtLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    buttonIcon: Icon(
                      Icons.place,
                      color: AppColors.TxtLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
