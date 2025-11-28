import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teeklit/domain/model/community/posts.dart';
import 'package:teeklit/ui/community/view_model/community_view_model.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

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
  final Posts postInfo;

  const PostCard({super.key, required this.postInfo,});

  @override
  Widget build(BuildContext context) {
    final String? postId = postInfo.postId;
    final String postTitle = postInfo.postTitle;
    final String postContents = postInfo.postContents;
    final List<String> imgUrls = postInfo.imgUrls;
    final String category = postInfo.category;
    final bool hasImage = imgUrls.isNotEmpty; // 이미지가 있으면 true

    return GestureDetector(
      onTap: () async {
        await context.read<CommunityViewModel>().selectedPost(postId!);
        context.go('/community/view');
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.roundboxDarkBg,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: hasImage ? 8 : 10,
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
                if (hasImage)
                  Expanded(flex: 2, child: PictureSection(imgUrls: imgUrls)),
              ],
            ),
            Divider(
              height: 5,
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryBox(category: category,),
                CommentCount(commentCount: 3, postId: postId,),
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
        color: AppColors.txtLight,
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
        color: AppColors.txtGray,
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
  final List<String>? imgUrls;

  const PictureSection({super.key, required this.imgUrls});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(imgUrls![0], fit: BoxFit.cover),
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
      '자유게시판' => AppColors.orange,
      '티클' => AppColors.green,
      '정보' => AppColors.blue,
      _ => AppColors.warningRed,
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
          color: AppColors.txtGray,
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
  final String? postId;

  const CommentCount({
    super.key,
    required this.commentCount, this.postId,
  });

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<int>( // TODO AI 사용해서 급조. 나중에 제대로 공부하겠음
      future: context.read<CommunityViewModel>().responseCommentCount(postId!),
      builder: (context, snapshot) {
        
        final loadedCount = snapshot.data ?? 0;

        return Row(
          children: [
            Icon(Icons.forum, color: AppColors.ivory, size: 12),
            Text(
              '$loadedCount',
              style: TextStyle(
                color: AppColors.txtGray,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}

