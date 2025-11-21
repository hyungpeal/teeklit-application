import 'package:flutter/material.dart';
import 'package:teeklit/config/colors.dart';

class ViewHeaderPostInfoSection extends StatelessWidget {
  
  /// 게시글 상세보기 페이지의 상단에서 게시글 정보를 포함하는 section
  /// * 제목
  /// * 작성자
  /// * 작성 시간
  const ViewHeaderPostInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            '집에서 안나가면 배달 시켜 드시나요?',
            style: TextStyle(
              color: AppColors.TxtLight,
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
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.TxtLight,
                  ),
                  Text(
                    '2025.11.11',
                    style: TextStyle(
                      color: AppColors.TxtLight,
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
