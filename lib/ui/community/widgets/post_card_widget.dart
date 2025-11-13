import 'package:flutter/material.dart';
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
  final double baseHeight;

  const PostCard({super.key, required this.postInfo, required this.baseHeight});

  @override
  Widget build(BuildContext context) {
    final String postTitle = postInfo['postTitle'];
    final String postContents = postInfo['postContents'];
    final String picUrl = postInfo['picUrl'];
    final String category = postInfo['category'];
    final int commentCount = postInfo['commentCount'];

    return Container(
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
                    PostTitle(postTitle: postTitle, baseHeight: baseHeight),
                    SizedBox(),
                    PostContents(
                      postContents: postContents,
                      baseHeight: baseHeight,
                    ),
                    PostContents(
                      postContents: '',
                      baseHeight: baseHeight,
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
            height: 3,
            color: AppColors.RoundboxDarkBg,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CategoryBox(category: category, baseHeight: baseHeight),
              CommentCount(commentCount: commentCount, baseHeight: baseHeight),
            ],
          ),
        ],
      ),
    );
  }
}

/// 제목 받아서 출력(String postTitle)
class PostTitle extends StatelessWidget {
  final String postTitle;
  final double baseHeight;

  const PostTitle({
    super.key,
    required this.postTitle,
    required this.baseHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      postTitle,
      style: TextStyle(
        color: AppColors.TxtLight,
        fontWeight: FontWeight.w800,
        fontSize: baseHeight * 0.02,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// 내용 받아서 출력
class PostContents extends StatelessWidget {
  final String postContents;
  final double baseHeight;

  const PostContents({
    super.key,
    required this.postContents,
    required this.baseHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      postContents,
      style: TextStyle(
        color: AppColors.TxtGrey,
        fontSize: baseHeight*0.015
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
  final double baseHeight;

  const CategoryBox({
    super.key,
    required this.category,
    required this.baseHeight,
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
          fontWeight: FontWeight.bold,
          fontSize: baseHeight * 0.011,
        ),
      ),
    );
  }
}

/// 댓글 갯수 출력
class CommentCount extends StatelessWidget {
  final int commentCount;
  final double baseHeight;

  const CommentCount({
    super.key,
    required this.commentCount,
    required this.baseHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.forum, color: AppColors.Ivory, size: baseHeight * 0.015),
        Text(
          '$commentCount',
          style: TextStyle(
            color: AppColors.TxtGrey,
            fontSize: baseHeight * 0.011,
          ),
        ),
      ],
    );
  }
}

//stateful 위젯들 (처분 예정)
// class CategoryBox extends StatefulWidget {
//   final String category;
//   final double height;
//
//   const CategoryBox({super.key, required this.category, required this.height});
//
//   @override
//   State<CategoryBox> createState() => _CategoryBoxState();
// }
// class _CategoryBoxState extends State<CategoryBox> {
//
//   @override
//   Widget build(BuildContext context) {
//     Color setColor = switch(widget.category){
//       '자유게시판' => Colors.orange,
//       '티클' => Colors.green,
//       '정보' => Colors.blue,
//       _ => Colors.white,
//     };
//
//     return Container(
//       decoration: BoxDecoration(
//         color: setColor,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       // height: widget.height,
//       padding: EdgeInsets.all(3),
//       child: Text(
//         widget.category,
//         style: TextStyle(
//           fontSize: widget.height * 0.08,
//           color: Color(0xff6C6C6C)
//         ),
//       ),
//
//     );
//   }
// }

// class PostTitle extends StatefulWidget {
//   final String postTitle;
//   final double height;
//
//   const PostTitle({super.key, required this.postTitle, required this.height});
//
//   @override
//   State<PostTitle> createState() => _PostTitleState();
// }
// class _PostTitleState extends State<PostTitle> {
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       widget.postTitle,
//       style: TextStyle(
//         fontSize: widget.height * 0.1,
//         color: Colors.white,
//         backgroundColor: Colors.black,
//       ),
//       maxLines: 1,
//       overflow: TextOverflow.ellipsis,
//     );
//   }
// }

// class PostContents extends StatefulWidget {
//   final String postContents;
//   final double height;
//
//   const PostContents({super.key, required this.postContents, required this.height});
//
//   @override
//   State<PostContents> createState() => _PostContentsState();
// }
// class _PostContentsState extends State<PostContents> {
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       widget.postContents,
//       style: TextStyle(
//         fontSize: widget.height*0.07,
//         color: Colors.white,
//         backgroundColor: Colors.black,
//       ),
//       maxLines: 1,
//       overflow: TextOverflow.ellipsis,
//     );
//   }
// }

// class PictureSection extends StatefulWidget {
//   final String picUrl;
//
//   /// asdf
//   const PictureSection({super.key, required this.picUrl});
//
//   @override
//   State<PictureSection> createState() => _PictureSectionState();
// }
// class _PictureSectionState extends State<PictureSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Image(
//         image: NetworkImage(widget.picUrl)
//     );
//   }
// }
