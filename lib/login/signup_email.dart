import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/utils/fullscreen.dart';

import '../ui/core/themes/app_text.dart';
import '../ui/core/themes/colors.dart';
import 'signup_info.dart';
import 'signup_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';  // 🔥 추가


// ⭐ info 구조 사용

// ⭐ 패스워드로 info 넘김

class SignupEmailScreen extends StatefulWidget {
  const SignupEmailScreen({super.key});

  @override
  State<SignupEmailScreen> createState() => _SignupEmailScreenState();
}

class _SignupEmailScreenState extends State<SignupEmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  //풀스크린
  @override
  void initState() {
    super.initState();
    Fullscreen.enable();
  }


  // 🔥 이메일 중복 체크 (하나만 남김)
  Future<bool> checkEmailExists(String email) async {
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: 'dummyPassword123!',
      );

      // 계정이 새로 생성되었음 = 존재하지 않았음
      // → 생성한 임시 계정 바로 삭제
      await cred.user?.delete();

      return false;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return true;
      }
      return false;
    }
  }



  // 🔥 공통 스낵바 함수 (하나만 남김)
  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool isNextEnabled = false;

  @override
  void dispose() {
    _emailController.dispose();

    Fullscreen.disable();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final reg = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return reg.hasMatch(email.trim());
  }

  void _checkValid(String text) {
    setState(() {
      isNextEnabled = isValidEmail(text);
    });
  }

  void _goNext() async {
    final email = _emailController.text.trim();

    if (!isValidEmail(email)) {
      showSnack("이메일 형식이 올바르지 않습니다.");
      return;
    }

    // 🔥 중복 체크
    final exists = await checkEmailExists(email);
    if (exists) {
      showSnack("이미 사용 중인 이메일입니다.");
      return;
    }

    // 정상
    final info = SignupInfo(email: email);
    context.push('/signup-password', extra: info);
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.chevron_left,
            size: 28,
            color: AppColors.strokeGray,
          ),
        ),
      ),

      bottomNavigationBar: SizedBox(
        height: 80,
        child: ElevatedButton(
          onPressed: isNextEnabled ? _goNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isNextEnabled
                ? AppColors.darkGreen
                : AppColors.txtGray,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Text(
            "다음",
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
            const SizedBox(height: 10),

            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "가입하실 ",
                    style: TextStyle(
                      fontFamily: 'Paperlogy',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.7,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "이메일",
                    style: TextStyle(
                      fontFamily: 'Paperlogy',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.7,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "을\n입력해주세요.",
                    style: TextStyle(
                      fontFamily: 'Paperlogy',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.7,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            TextField(
              controller: _emailController,
              onChanged: _checkValid,
              decoration: InputDecoration(
                hintText: '이메일 주소 입력',
                hintStyle: const TextStyle(
                  fontFamily: 'Paperlogy',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: const Color(0xFF555555),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Paperlogy',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }
}
