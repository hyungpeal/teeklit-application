import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teeklit/domain/model/community/posts.dart';
import 'package:teeklit/ui/community/view_model/community_view_model.dart';
import 'package:teeklit/ui/community/widgets/main_page/main_post_card_section.dart';

class MainBodyPostCards extends StatefulWidget {
  const MainBodyPostCards({super.key});

  @override
  State<MainBodyPostCards> createState() => _MainBodyPostCardsState();
}

class _MainBodyPostCardsState extends State<MainBodyPostCards> {
  final ScrollController _scrollController = ScrollController();

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
  Future<void> _getPostInfo() async{
    // context.read<CommunityViewModel>().mainCategory = PostCategory.popular;
    await context.read<CommunityViewModel>().firstLoadPosts();
  }
  
  // 스크롤 바닥에 닿는지 확인, 닿기 전 함수 실행
  void _onScroll() {
    if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200){
      context.read<CommunityViewModel>().loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {

    final postList = context.watch<CommunityViewModel>().postList;

    return RefreshIndicator(
      onRefresh: () async {
        await _getPostInfo();
      },
      child: ListView.separated(
        controller: _scrollController,
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        itemCount: postList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return PostCard(
            postInfo: postList[index],
          );
        },
      ),
    );
  }
}
