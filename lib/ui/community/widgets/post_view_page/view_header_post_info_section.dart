import 'package:flutter/material.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

class ViewHeaderPostInfoSection extends StatelessWidget {
  final String title;
  final String? imgUrl;
  final String nickName;
  final DateTime time;

  /// 게시글 상세보기 페이지의 상단에서 게시글 정보를 포함하는 section
  /// * 제목
  /// * 작성자
  /// * 작성 시간
  const ViewHeaderPostInfoSection({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.nickName,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.txtLight,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        // 이미지 닉네임 시간
        Padding(
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
                      imgUrl ?? 'https://cdn.epnnews.com/news/photo/202008/5216_6301_1640.jpg',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  nickName,
                  style: TextStyle(
                    color: AppColors.txtLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.txtLight,
                  ),
                  Text(
                    time.toString(),
                    style: TextStyle(
                      color: AppColors.txtLight,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
