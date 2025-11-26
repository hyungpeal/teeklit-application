import 'package:flutter/material.dart';
import 'package:teeklit/domain/model/community/posts.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

/// 글쓰기 페이지 카테고리
class PostCategorySection extends StatefulWidget {
  final TextEditingController controller;

  /// 글쓰기 페이지 카테고리 선택 부분. modal bottom sheet 호출함
  const PostCategorySection({super.key, required this.controller});

  @override
  State<PostCategorySection> createState() => _PostCategorySectionState();
}

class _PostCategorySectionState extends State<PostCategorySection> {
  Future<void> _openModal() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      backgroundColor: AppColors.bg,
      builder: (context) {
        final List<String> categoryList = [
          PostCategory.free.value,
          PostCategory.teekle.value,
          PostCategory.info.value,
        ];
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColors.bg,
                  flexibleSpace: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  title: Text(
                    '카테고리',
                    style: TextStyle(
                      color: AppColors.txtLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    clipBehavior: Clip.hardEdge,
                    children: [
                      for (String category in categoryList) ...[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          // TODO 바텀시트바 상단 침범하는거 해결하기
                          child: ListTile(
                            enableFeedback: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(25),
                            ),
                            tileColor: AppColors.roundboxDarkBg,
                            title: Text(
                              category,
                              style: TextStyle(
                                color: AppColors.txtLight,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () => Navigator.pop(context, category),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        widget.controller.text = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: AppColors.txtLight),
      readOnly: true,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: '주제 선택',
        hintStyle: TextStyle(
          color: AppColors.txtLight,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.strokeGray),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.strokeGray),
        ),
        suffixIcon: Icon(Icons.chevron_right),
      ),
      onTap: _openModal,
    );
  }
}
