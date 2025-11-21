import 'package:flutter/material.dart';

/*
* 목록이 스크롤 가능할만큼 갯수가 충분하다는 걸 보여주기 위한 그라데이션 위젯 입니다.
* 위 , 아래 둘 다 넣을라면 위젯 2번 호출해야 합니다!
*
* 사용법 :
* const ScrollGradientOverlay(
    gradientColor: AppColors.BottomSheetBg,
    direction: GradientDirection.bottom,
  ),
* 란님 코드
*
* */


// 그라디언트 오버레이 방향 정의
enum GradientDirection { top, bottom }

// 목록이 스크롤 가능할만큼 갯수가 충분하다는 걸 보여주기 위한 그라데이션 위젯 입니다.
class ScrollGradientOverlay extends StatelessWidget {
  // 그라디언트 색 입니다. 설정한 색 -> transparent로 됨!
  final Color gradientColor;

  // 그라데이션 방향 : 위에서 아래로, 아래에서 위로
  final GradientDirection direction;

  const ScrollGradientOverlay({
    super.key,
    required this.gradientColor,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final isTop = direction == GradientDirection.top;
    return Positioned(
      top: isTop ? 0 : null,
      bottom: isTop ? null : 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          height: isTop ? 20.0 : 30.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isTop
                  ? [gradientColor, gradientColor.withValues(alpha: 0.0)]
                  : [gradientColor.withValues(alpha: 0.0), gradientColor],
            ),
          ),
        ),
      ),
    );
  }
}
