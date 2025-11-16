import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_button_widgets.dart';

/// 게시글 상세보기 페이지 댓글창
class ViewCommentSection extends StatelessWidget {
  final bool isRecomment;
  final List<ViewCommentSection> replies;

  const ViewCommentSection({
    super.key,
    this.isRecomment = false,
    this.replies = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRecomment ? Color(0xff242424) : AppColors.Bg,
      child: Column(
        children: [
          // 댓글 정보 TODO 매개변수로 댓글 정보와 내용 등 넘겨주고 아래 함수도 수정
          _buildCommentInfo(),
          // 댓글 내용, 좋아요와 댓글달기 버튼
          _buildCommentBody(),

          // 재귀
          if (replies.isNotEmpty)
            Container(
              color: AppColors.Bg,
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                children: replies,
              ),
            ),
        ],
      ),
    );
  }

  // 댓글 정보
  Widget _buildCommentInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: EdgeInsets.only(right: 5),
            child: AspectRatio(
              aspectRatio: 1,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://cdn.epnnews.com/news/photo/202008/5216_6301_1640.jpg',
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              '관악구치킨왕',
              style: TextStyle(
                color: AppColors.TxtLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            spacing: 5,
            children: [
              Text(
                '6시간전',
                style: TextStyle(
                  color: AppColors.InactiveTxtGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Icon(
                Icons.more_vert,
                size: 16,
                color: AppColors.InactiveTxtGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 댓글 내용
  Widget _buildCommentBody() {
    return Row(
      children: [
        SizedBox.fromSize(
          size: Size(30, 30),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '요즘에 도시락 정기배달 해주는 업체도 있긴 하더라고요.. 좋아보이던데.. ㅠ 근데 저는 그냥 집에서 파스타 같은 한그릇 요리 간단하게 해먹어요!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.TxtLight,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    CustomTextIconButton(
                      buttonText: Text(
                        '3',
                        style: TextStyle(
                          color: AppColors.TxtLight,
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      ),
                      buttonIcon: Icon(
                        Icons.thumb_up_alt_outlined,
                        size: 14,
                        color: AppColors.TxtLight,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        '댓글달기',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.TxtLight,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
