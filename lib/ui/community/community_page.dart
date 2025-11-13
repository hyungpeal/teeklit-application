import 'dart:math';

import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_button_widgets.dart';
import 'package:teeklit/ui/community/widgets/post_card_widget.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

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
    EdgeInsets padding = MediaQuery.of(context).padding;
    double safeHeight = MediaQuery.of(context).size.height - padding.top;
    double bottomHeight = 0;
    double bodyHeight = safeHeight - bottomHeight;

    // Scaffold.of(context).appBarMaxHeight;

    return Scaffold(
      // appBar 안쓰기 -> 그냥 body에 column 추가? appBar 안쓰면 안이뻐보임
      // 아니면 appbar 높이 조절해주기
      appBar: AppBar(
        backgroundColor: AppColors.Bg,
        title: Text(
          '커뮤니티',
          style: TextStyle(
            color: AppColors.TxtLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, color: AppColors.Ivory),
          ),
        ],
      ),
      body: Container(
        height: bodyHeight,
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        color: AppColors.Bg,
        child: Column(
          children: [
            Expanded(
              // flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                        CategoryToggleButtons(categories: categoryList),
                      // for (final String category in categoryList) ...[
                        // CategoryButton(category: category),
                        // // 인기 다음에 vertical divider 넣고싶은데.. if 쓰기는 싫고
                        // // ? gpt 왈: if랑 switch랑 성능 크게 차이 안난다. dart의 switch도 순차구문이다
                        // // 그럼 걍 if 써야겠다 (팩트체크 안됨. 구글링하기 시간 없음 -> 제대로 안찾아보긴 했음)
                        // // 코드 더러워져서 CategoryButton 안에 넣어봤는데 박스 안에 들어가지네 여기가 맞는 위치인듯??
                        // if (category case (== '인기')) ...[
                        //   LayoutBuilder(
                        //     builder: (context, constraints) {
                        //       double height = constraints.maxHeight;
                        //
                        //       return VerticalDivider(
                        //         indent: height * 0.25,
                        //         endIndent: height * 0.25,
                        //       );
                        //     },
                        //   ),
                        // ],
                      // ],
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: ListView.separated(
                itemCount: dummyPosts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return PostCard(postInfo: dummyPosts[index], baseHeight: bodyHeight,);
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

//TODO 게시글 터치 시 라우팅
//TODO 세세한 디자인 조정
