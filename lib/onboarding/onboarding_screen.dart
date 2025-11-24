import 'package:flutter/material.dart';

import '../ui/core/themes/colors.dart';
import 'package:go_router/go_router.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _index = i),
            children: const [
              OnboardingPage1(),
              OnboardingPage2(),
              OnboardingPage3(),
            ],
          ),

          /// ─────────────────────────────
          ///    인디케이터
          /// ─────────────────────────────
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                    _index == i ? const Color(0xFFBFD8A5) : Colors.grey[600],
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),

          /// ─────────────────────────────
          ///    공통 버튼
          /// ─────────────────────────────
          Positioned(
            left: 50,
            top: MediaQuery.of(context).size.height * 0.85, // 화면의 80%
            child: SizedBox(
              width: 300,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFBFD8A5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                onPressed: () {
                  context.go('/login');
                },
                child: const Text(
                  "지금 함께해요!",
                  style: TextStyle(
                    fontFamily: "Paperlogy",
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// 온보딩 1

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 이미지 (위쪽 고정)
        Positioned(
          top: 170,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF97A985).withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 70,
                  spreadRadius: 4,
                ),
              ],
            ),

            /// 📌 child 안에 넣어야 한다!!
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: Image.asset(
                "assets/images/Onboarding1.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        /// 텍스트 (절대 고정)
        const Positioned(
          left: 40,
          bottom: 180,
          child: SizedBox(
            width: 260,
            child: Text(
              "괜찮아! 혼자가 아닌,\n함께 다시 내딛는 첫걸음.",
              style: TextStyle(
                fontFamily: "Paperlogy",
                fontSize: 22,
                height: 1.4,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


// 온보딩 2

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 이미지
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Image.asset(
            "assets/images/Onboarding2.png",
            width: 360,
            fit: BoxFit.contain,
          ),
        ),

        /// 텍스트 (고정 위치)
        const Positioned(
          left: 40,
          bottom: 180,
          child: SizedBox(
            width: 260,
            child: Text(
              "나만의 작은 티클로\n일상을 조금씩 채워나가요.",
              style: TextStyle(
                fontFamily: "Paperlogy",
                fontSize: 22,
                height: 1.4,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}



// 온보딩 3
class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 이미지
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Image.asset(
            "assets/images/Onboarding3.png",
            width: 360,
            fit: BoxFit.contain,
          ),
        ),

        /// 텍스트
        const Positioned(
          left: 40,
          bottom: 180,
          child: SizedBox(
            width: 260,
            child: Text(
              "함께 인증하고,\n서로의 변화를 응원하세요.",
              style: TextStyle(
                fontFamily: "Paperlogy",
                fontSize: 22,
                height: 1.4,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
