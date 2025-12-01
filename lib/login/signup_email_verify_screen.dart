import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/login/signup_info.dart';
import 'package:teeklit/utils/fullscreen.dart';
import 'app_router.dart';
import 'signup_info.dart';

import '../ui/core/themes/app_text.dart';
import '../ui/core/themes/colors.dart';

class SignupEmailVerifyScreen extends StatefulWidget {
  final SignupInfo info;

  const SignupEmailVerifyScreen({
    super.key,
    required this.info,
  });

  @override
  State<SignupEmailVerifyScreen> createState() =>
      _SignupEmailVerifyScreenState();
}

class _SignupEmailVerifyScreenState extends State<SignupEmailVerifyScreen> {

  @override
  void initState() {
    super.initState();
    Fullscreen.enable();
  }

  @override
  void dispose() {
    Fullscreen.disable();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/login'),
          icon: Icon(
            Icons.chevron_left,
            color: AppColors.strokeGray,
            size: 28,
          ),
        ),
      ),

      bottomNavigationBar: SizedBox(
        height: 80,
        child: ElevatedButton(
          onPressed: () {
            context.go('/login');   // 🔥 로그인 화면으로 이동
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkGreen,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Text(
            "회원가입 완료!",
            style: AppText.Button.copyWith(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            const Text(
              "본인확인을 위해 이메일로",
              style: TextStyle(
                fontFamily: 'Paperlogy',
                fontWeight: FontWeight.w500,
                fontSize: 22,
                height: 1.6,
                color: Colors.white,
              ),
            ),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "전송된 링크로 ",
                    style: TextStyle(
                      fontFamily: 'Paperlogy',
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      height: 1.6,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "인증",
                    style: TextStyle(
                      fontFamily: 'Paperlogy',
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      height: 1.6,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "을 진행해주세요.",
                    style: TextStyle(
                      fontFamily: 'Paperlogy',
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      height: 1.6,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.03),

            const Text(
              "발송된 이메일",
              style: TextStyle(
                fontFamily: 'Paperlogy',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.5,
                color: AppColors.txtLight,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              widget.info.email,
              style: const TextStyle(
                fontFamily: 'Paperlogy',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 1.4,
                color: AppColors.lightGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
