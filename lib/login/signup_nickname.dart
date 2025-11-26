import 'package:flutter/material.dart';

// ⭐ info 기반 구조 통일

// ⭐ 프로필 화면

import '../ui/core/themes/app_text.dart';
import '../ui/core/themes/colors.dart';
import 'signup_info.dart';
import 'signup_profile_screen.dart';
import 'package:go_router/go_router.dart';

class SignupNicknameScreen extends StatefulWidget {
  final SignupInfo info;   // ⭐ email + password 들어 있음

  const SignupNicknameScreen({
    super.key,
    required this.info,
  });

  @override
  State<SignupNicknameScreen> createState() => _SignupNicknameScreenState();
}

class _SignupNicknameScreenState extends State<SignupNicknameScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _nicknameController.addListener(() {
      final text = _nicknameController.text.trim();
      setState(() {
        isButtonEnabled = text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _onNext() {
    final nickname = _nicknameController.text.trim();

    // ⭐ info에 nickname 추가
    final updatedInfo = widget.info.copyWith(nickname: nickname);

    context.push('/signup-profile', extra: updatedInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 28,
            color: AppColors.strokeGray,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "가입을 축하합니다! 👏🏻\n",
                    style: AppText.H1.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  TextSpan(
                    text: "어떻게 불러드리면 될까요?",
                    style: AppText.H1.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            Text(
              "닉네임",
              style: AppText.Body1.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _nicknameController,
              style: AppText.Body1.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: '닉네임을 입력해주세요.',
                hintStyle: AppText.Body2.copyWith(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF4A4A4A),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SizedBox(
        height: 80,
        child: ElevatedButton(
          onPressed: isButtonEnabled ? _onNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isButtonEnabled
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
    );
  }
}