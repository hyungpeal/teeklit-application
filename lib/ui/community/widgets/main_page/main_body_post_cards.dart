import 'dart:math';

import 'package:flutter/material.dart';
import 'package:teeklit/ui/community/widgets/main_page/main_post_card_section.dart';

class MainBodyPostCards extends StatefulWidget {
  const MainBodyPostCards({super.key});

  @override
  State<MainBodyPostCards> createState() => _MainBodyPostCardsState();
}

class _MainBodyPostCardsState extends State<MainBodyPostCards> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  int dummyCount = 0;
  List<Map<String, dynamic>> dummyPostSave = [];

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getPostInfo();
    _scrollController.addListener(_onScroll);
  }
  
  // 서버에서 데이터 받아와서 초기화
  void _getPostInfo() {
    dummyCount = 0;
    if(dummyPostSave.isNotEmpty) dummyPostSave.clear();
    dummyPostSave.addAll(dummyPosts());
  }
  
  // 스크롤 바닥에 닿는지 확인, 닿기 전 함수 실행
  void _onScroll() {
    if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200){
      _leadMore();
    }
  }

  // 데이터 더 받아오는 함수 실행
  Future _leadMore() async{
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      dummyPostSave.addAll(dummyPosts());
      isLoading = false;
    });
  }

  // 더미데이터 생성하는 코드
  final random = Random();

  final imageList = [
    'https://www.sputnik.kr/article_img/202405/article_1714655499.jpg',
    'https://cdn.epnnews.com/news/photo/202008/5216_6301_1640.jpg',
    'https://imgnn.seoul.co.kr/img/upload/2014/07/31/SSI_20140731103709.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx4eEpxHvuHh_dxuMHR7O1RisXLKDtcmTteQ&s',
  ];

  final List<String> categoryList = ['인기', '티클', '자유게시판', '정보', '지도'];

  List<Map<String, dynamic>> dummyPosts() {
    return List.generate(20, (_) {
      dummyCount++;
      bool hasImage = dummyCount % 2 == 0; // 절반은 null, 절반은 이미지
      return {
        'postId': 'post$dummyCount',
        'postTitle': '게시글 제목 $dummyCount',
        'postContents': '이것은 게시글 $dummyCount의 내용입니다. 더미 데이터입니다.',
        'picUrl': hasImage
            ? imageList[random.nextInt(imageList.length)]
            : 'null',
        'category': categoryList[random.nextInt(categoryList.length)],
        'commentCount': random.nextInt(101),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _getPostInfo();
        });
      },
      child: ListView.separated(
        controller: _scrollController,
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        itemCount: dummyPostSave.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return PostCard(
            postInfo: dummyPostSave[index],
          );
        },
      ),
    );
  }
}
