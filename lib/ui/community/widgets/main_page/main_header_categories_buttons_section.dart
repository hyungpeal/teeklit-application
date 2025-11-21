import 'package:flutter/material.dart';
import 'package:teeklit/ui/community/widgets/main_page/main_category_toggle_buttons.dart';

class MainHeaderCategoriesButtonsSection extends StatelessWidget {
  /// community main page의 상단 헤더에 들어갈 카테고리 버튼 section
  const MainHeaderCategoriesButtonsSection({super.key,});

  @override
  Widget build(BuildContext context) {
    final List<String> categoryList = ['인기', '티클', '자유게시판', '정보', '지도'];

    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MainCategoryToggleButtons(categories: categoryList),
          ],
        ),
      ),

    );
    // TODO 강사님 코드. layoutBuilder 대신 chip 써서 만들어보기(시간 있을 때)
    // return   ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     itemCount: categoryList.length,
    //     itemBuilder:(BuildContext ctx, int idx){
    //       Chip chip=Chip(
    //         label: Text('인기',style:  Theme.of(context).textTheme.bodyLarge,),
    //       );
    //       if(idx==0){
    //         return Row(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             chip,
    //             Divider(height: Theme.of(context).textTheme.bodyLarge?.height, thickness: 2,color: Colors.grey.shade300,)
    //           ],
    //         );
    //       }
    //       return chip;
    //     }
    //
    // );
  }
}
