import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teeklit/ui/community/view_model/community_view_model.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/community/widgets/post_write_page/write_app_bar.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';
import 'package:teeklit/ui/community/widgets/post_write_page/write_custom_text_form_field.dart';
import 'package:teeklit/ui/community/widgets/post_write_page/write_category_section.dart';
import 'package:teeklit/ui/community/widgets/post_write_page/write_media_section.dart';

class CommunityPostWritePage extends StatefulWidget {
  const CommunityPostWritePage({super.key});

  @override
  State<CommunityPostWritePage> createState() => _CommunityPostWritePageState();
}

class _CommunityPostWritePageState extends State<CommunityPostWritePage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();

  late double bottomPadding = MediaQuery.paddingOf(context).bottom;

  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();

    if (picked.isNotEmpty) {
      setState(() {
        // _images.addAll(picked);
        _images.addAll(picked.map((xfile) => File(xfile.path)).toList());
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _contentsController.dispose();

    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating, // 떠있는 스타일
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formkey.currentState!.validate()) {
      final postTitle = _titleController.text;
      final category = _categoryController.text;
      final postContents = _contentsController.text;

      final vm = context.read<CommunityViewModel>();

      if (vm.myId.isEmpty) {
        _showSnackBar(context, '로그인 정보가 유효하지 않습니다.');
        return;
      }

      if(postTitle.isEmpty) {
        _showSnackBar(context, '제목을 입력해주세요.');
        return;
      }

      if (category.isEmpty) {
        _showSnackBar(context, '카테고리를 선택해주세요.');
        return;
      }

      if (postContents.isEmpty) {
        _showSnackBar(context, '내용을 입력해주세요.');
        return;
      }

      try {
        await vm.addPost(
            postTitle,
            postContents,
            category,
            _images
        );

        if (context.mounted) { // 비동기 후 context 살아있는지 확인
          context.goNamed('communityMain');
          _showSnackBar(context, '게시글이 등록되었습니다.');
        }
      } catch (e) {
        if (context.mounted) {
          _showSnackBar(context, '게시글 등록에 실패했습니다: $e');
        }
      }

      // context.read<CommunityViewModel>().addPost(postTitle, postContents, category, _images);
      // context.goNamed('communityMain');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: WriteAppBar(
        actions: [
          CustomTextButton(
            buttonText: Text(
              '저장',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: AppColors.ivory,
              ),
            ),
            callback: _submitForm,
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      WriteCustomTextFormField(
                        hintText: Text(
                          '제목',
                          style: TextStyle(
                            color: AppColors.txtLight,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        fieldType: InputFieldType.title,
                        controller: _titleController,
                      ),
                      SizedBox(height: 10),
                      PostCategorySection(
                        controller: _categoryController,
                      ),
                      SizedBox(height: 10),
                      WriteCustomTextFormField(
                        hintText: Text(
                          '함께 살아가는 이야기를 들려주세요.\n오늘 내 무브는 어땠나요?',
                          style: TextStyle(
                            color: AppColors.txtGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                        fieldType: InputFieldType.content,
                        controller: _contentsController,
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            WriteMediaSection(
                onPickImages: _pickImages,
                images: _images,
              onRemoveImage: (img) {
                setState(() => _images.remove(img));
              },
            ),
          ],
        ),
      ),
    );
  }

}
