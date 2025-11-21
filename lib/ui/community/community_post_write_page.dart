import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teeklit/config/colors.dart';
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

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked);
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

  // TODO 서버 전송 기능 구현
  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      final title = _titleController.text;
      final category = _categoryController;
      final contents = _contentsController.text;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('게시글 작성')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Bg,
      appBar: WriteAppBar(
        actions: [
          CustomTextButton(
            buttonText: Text(
              '저장',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: AppColors.Ivory,
              ),
            ),
            callback: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                WriteCustomTextFormField(
                  hintText: Text(
                    '제목',
                    style: TextStyle(
                      color: AppColors.TxtLight,
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
                      color: AppColors.TxtGrey,
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
      bottomSheet: WriteMediaSection(
        bottomPadding: bottomPadding,
        onPickImages: _pickImages,
        images: _images,
        onRemoveImage: (img) {
          setState(() => _images.remove(img));
        },
      ),
    );
  }
}
