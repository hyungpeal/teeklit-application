import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

/// 게시글 상세보기 페이지 댓글창
class ViewFooterCommentContentsSection extends StatefulWidget {
  final bool isRecomment;

  /// 댓글 보여주는 위젯
  const ViewFooterCommentContentsSection({
    super.key,
    this.isRecomment = false,
  });

  @override
  State<ViewFooterCommentContentsSection> createState() => _ViewFooterCommentContentsSectionState();
}

class _ViewFooterCommentContentsSectionState extends State<ViewFooterCommentContentsSection> {
  // modal 모달
  Future<void> _openModal() async {
    await showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      backgroundColor: AppColors.Bg,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.TxtGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: CustomTextButton(
                    buttonText: Text(
                      '신고',
                      style: TextStyle(
                        color: AppColors.Ivory,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    callback: () {},
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.TxtGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: CustomTextButton(
                    buttonText: Text(
                      '차단',
                      style: TextStyle(
                        color: AppColors.Ivory,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    callback: () {},
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.WarningRed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: CustomTextButton(
                    buttonText: Text(
                      '취소',
                      style: TextStyle(
                        color: AppColors.Ivory,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    callback: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
              CustomIconButton(
                buttonIcon: Icon(
                  Icons.more_vert,
                  color: AppColors.TxtGrey,
                  size: 16,
                ),
                callback: _openModal,
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
                      callback: (){},
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isRecomment ? Color(0xff242424) : AppColors.Bg,
        border: widget.isRecomment ? Border(top: BorderSide(color: AppColors.StrokeGrey)) : Border(bottom: BorderSide(color: AppColors.StrokeGrey))
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: EdgeInsets.only(
              left: widget.isRecomment ? 45 : 15,
              right: 15,
            ),
            child: Column(
              children: [
                // 댓글 정보 TODO 매개변수로 댓글 정보와 내용 등 넘겨주고 아래 함수도 수정
                _buildCommentInfo(),
                // 댓글 내용, 좋아요와 댓글달기 버튼
                _buildCommentBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
