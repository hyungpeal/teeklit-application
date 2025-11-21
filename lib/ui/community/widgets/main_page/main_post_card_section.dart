import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/config/colors.dart';

/// 게시글 리스트에 출력되는 게시글 정보들.
///
/// [Map{
/// postTitle: String ,
/// postContents: String ,
/// picUrl: String ,
/// category: String ,
/// commentCount: int
/// }]
class PostCard extends StatelessWidget {
  final Map<String, dynamic> postInfo;

  const PostCard({super.key, required this.postInfo});

  @override
  Widget build(BuildContext context) {
    final String postTitle = postInfo['postTitle'];
    final String postContents = postInfo['postContents'];
    final String picUrl = postInfo['picUrl'];
    final String category = postInfo['category'];
    final int commentCount = postInfo['commentCount'];

    return GestureDetector(
      onTap: (){GoRouter.of(context).push('/community/view');},
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.RoundboxDarkBg,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: picUrl != 'null' ? 8 : 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostTitle(postTitle: postTitle),
                      SizedBox(),
                      PostContents(
                        postContents: postContents,
                      ),
                      PostContents(
                        postContents: '',
                      ),
                    ],
                  ),
                ),
                if (picUrl != 'null')
                  Expanded(flex: 2, child: PictureSection(picUrl: picUrl)),
              ],
            ),
            Divider(
              // 야매로 한거임
              // sizedbox(고정값) 주기 싫었음
              // height 3도 하드코딩이긴한데
              height: 5,
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryBox(category: category,),
                CommentCount(commentCount: commentCount,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 제목 받아서 출력(String postTitle)
class PostTitle extends StatelessWidget {
  final String postTitle;

  const PostTitle({
    super.key,
    required this.postTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      postTitle,
      style: TextStyle(
        color: AppColors.TxtLight,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// 내용 받아서 출력
class PostContents extends StatelessWidget {
  final String postContents;

  const PostContents({
    super.key,
    required this.postContents,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      postContents,
      style: TextStyle(
        color: AppColors.TxtGrey,
        fontSize: 13,
        fontWeight: FontWeight.w400
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// 사진 url을 받아서 출력함.
class PictureSection extends StatelessWidget {
  final String picUrl;

  const PictureSection({super.key, required this.picUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(picUrl, fit: BoxFit.cover),
      ),
    );
  }
}

/// 카테고리 박스 만드는 위젯.
class CategoryBox extends StatelessWidget {
  final String category;

  const CategoryBox({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    Color setColor = switch (category) {
      '자유게시판' => AppColors.Orange,
      '티클' => AppColors.Green,
      '정보' => AppColors.Blue,
      _ => AppColors.WarningRed,
    };

    return Container(
      decoration: BoxDecoration(
        color: setColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),

      alignment: Alignment.center,
      child: Text(
        category,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.TxtGrey,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}

/// 댓글 갯수 출력
class CommentCount extends StatelessWidget {
  final int commentCount;

  const CommentCount({
    super.key,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.forum, color: AppColors.Ivory, size: 12),
        Text(
          '$commentCount',
          style: TextStyle(
            color: AppColors.TxtGrey,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

