import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/main_page/main_app_bar.dart';
import 'package:teeklit/ui/community/widgets/main_page/main_body_post_cards.dart';
import 'package:teeklit/ui/community/widgets/main_page/main_header_categories_buttons_section.dart';
import 'package:teeklit/ui/community/widgets/main_page/main_post_write_button.dart';

class CommunityMainPage extends StatelessWidget {
  const CommunityMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        color: AppColors.Bg,
        child: Column(
          children: [
            Expanded(
              child: MainHeaderCategoriesButtonsSection(),
            ),
            // SizedBox(
            //   height: Theme.of(context).textTheme.headlineLarge?.height,
            //   child:MainHeaderCategoriesButtons(categoryList: categoryList),
            // ),
            Expanded(
                flex: 14,
                child: MainBodyPostCards(),
              ),
          ],
        ),
      ),
      floatingActionButton: PostWriteButton(),
      bottomNavigationBar: null,
    );
  }
}