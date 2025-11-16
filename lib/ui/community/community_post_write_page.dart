import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_appbar_widget.dart';
import 'package:teeklit/ui/community/widgets/community_button_widgets.dart';
import 'package:teeklit/ui/community/widgets/post_write_page/custom_text_form_field.dart';
import 'package:teeklit/ui/community/widgets/post_write_page/post_category_section.dart';
import 'package:teeklit/ui/community/widgets/post_write_page/post_media_section.dart';

class CommunityPostWritePage extends StatefulWidget {
  const CommunityPostWritePage({super.key});

  @override
  State<CommunityPostWritePage> createState() => _CommunityPostWritePageState();
}

class _CommunityPostWritePageState extends State<CommunityPostWritePage> {
  final _formkey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _contentsController = TextEditingController();

  // late EdgeInsets padding = MediaQuery.of(context).padding;
  late double bottomPadding = MediaQuery.paddingOf(context).bottom;

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _contentsController.dispose();

    super.dispose();
  }

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
      appBar: CustomAppBar(actions: [
        CustomTextButton(buttonText: '저장', callback: _submitForm,)
      ],),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CustomTextFormField(
                hint: '제목',
                fieldType: InputFieldType.title,
                controller: _titleController,
              ),
              SizedBox(height: 10),
              PostCategorySection(controller: _categoryController,),
              SizedBox(height: 10),
              CustomTextFormField(
                hint: '함께 살아가는 이야기를 들려주세요.\n오늘 내 무브는 어땠나요?',
                fieldType: InputFieldType.content,
                controller: _contentsController,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: PostMediaSection(bottomPadding: bottomPadding),
    );
  }
}
