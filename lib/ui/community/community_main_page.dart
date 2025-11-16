import 'dart:math';

import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/main_page/category_toggle_buttons.dart';
import 'package:teeklit/ui/community/widgets/main_page/main_app_bar.dart';
import 'package:teeklit/ui/community/widgets/main_page/post_write_button.dart';
import 'package:teeklit/ui/community/widgets/main_page/post_card_widget.dart';

class CommunityMainPage extends StatelessWidget {
  const CommunityMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> categoryList = ['인기', '티클', '자유게시판', '정보', '지도'];

    // 더미데이터 생성하는 코드
    final random = Random();
    final imageList = [
      'https://www.sputnik.kr/article_img/202405/article_1714655499.jpg',
      'https://cdn.epnnews.com/news/photo/202008/5216_6301_1640.jpg',
      'https://imgnn.seoul.co.kr/img/upload/2014/07/31/SSI_20140731103709.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx4eEpxHvuHh_dxuMHR7O1RisXLKDtcmTteQ&s',
    ];
    List<Map<String, dynamic>> dummyPosts = List.generate(100, (index) {
      bool hasImage = index % 2 == 0; // 절반은 null, 절반은 이미지
      return {
        'postId': 'post${index + 1}',
        'postTitle': '게시글 제목 ${index + 1}',
        'postContents': '이것은 게시글 ${index + 1}의 내용입니다. 더미 데이터입니다.',
        'picUrl': hasImage
            ? imageList[random.nextInt(imageList.length)]
            : 'null',
        'category': categoryList[random.nextInt(categoryList.length)],
        'commentCount': random.nextInt(101),
      };
    });

    // 본 코드

    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        color: AppColors.Bg,
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                        CategoryToggleButtons(categories: categoryList),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 12,
              // TODO pull to refresh -> ios 스타일로 만들어보기
              child: ListView.separated(
                itemCount: dummyPosts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return PostCard(postInfo: dummyPosts[index],);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: null,
      floatingActionButton: PostWriteButton(),
    );
  }
}