import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teeklit/domain/model/community/modify_image.dart';
import 'package:teeklit/domain/model/community/posts.dart';
import 'package:teeklit/ui/community/view_model/community_view_model.dart';
import 'package:teeklit/ui/community/widgets/post_modify_page/modify_app_bar.dart';
import 'package:teeklit/ui/community/widgets/post_modify_page/modify_media_section.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';
import 'package:teeklit/ui/community/widgets/post_write_page/write_custom_text_form_field.dart';
import 'package:teeklit/ui/community/widgets/post_write_page/write_category_section.dart';

class CommunityPostModifyPage extends StatefulWidget {
  const CommunityPostModifyPage({super.key});

  @override
  State<CommunityPostModifyPage> createState() => _CommunityPostModifyPageState();
}

class _CommunityPostModifyPageState extends State<CommunityPostModifyPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();

  late Posts post = context.read<CommunityViewModel>().post;

  List<ModifyImage> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();

    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(
          picked.map((xfile) => ModifyImage.fromFile(File(xfile.path))),
        );
      });
    }
  }

  void _loadPage() {
    _titleController.text = post.postTitle;
    _categoryController.text = post.category;
    _contentsController.text = post.postContents;
    _images = post.imgUrls.map((url) => ModifyImage.fromUrl(url)).toList();

  }

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _contentsController.dispose();

    super.dispose();
  }

  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      final postTitle = _titleController.text;
      final category = _categoryController.text;
      final postContents = _contentsController.text;

      context.read<CommunityViewModel>().modifyPost(postTitle, postContents, category, _images);

      /// TODO 이동 시, 메인 페이지 초기화
      context.go('/community');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: ModifyAppBar(
        actions: [
          CustomTextButton(
            buttonText: Text(
              '수정하기',
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

            ModifyMediaSection(
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
