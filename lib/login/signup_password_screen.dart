import 'package:flutter/material.dart';

import '../ui/core/themes/colors.dart';
import 'signup_info.dart';
import 'signup_nickname.dart';
import 'package:go_router/go_router.dart';

class SignupPasswordScreen extends StatefulWidget {
  final SignupInfo info;   // ⭐ 이메일 포함됨

  const SignupPasswordScreen({
    super.key,
    required this.info,
  });

  @override
  State<SignupPasswordScreen> createState() => _SignupPasswordScreenState();
}

class _SignupPasswordScreenState extends State<SignupPasswordScreen> {
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();
  bool isButtonEnabled = false;

  void _validate() {
    final pw = _pwController.text.trim();
    final pw2 = _pwConfirmController.text.trim();

    setState(() {
      isButtonEnabled = pw.isNotEmpty && pw2.isNotEmpty && pw == pw2;
    });
  }

  @override
  void dispose() {
    _pwController.dispose();
    _pwConfirmController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    final pw = _pwController.text.trim();
    final pw2 = _pwConfirmController.text.trim();

    if (pw.isEmpty || pw2.isEmpty) {
      _showMsg("비밀번호를 모두 입력해주세요.");
      return;
    }

    if (pw.length < 6) {
      _showMsg("비밀번호는 최소 6자 이상이어야 해요.");
      return;
    }

    if (pw != pw2) {
      _showMsg("비밀번호가 일치하지 않습니다.");
      return;
    }

    /// ⭐ info에 password 추가
    final updatedInfo = widget.info.copyWith(password: pw);

    context.push('/signup-nickname', extra: updatedInfo);
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
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

      bottomNavigationBar: SizedBox(
        height: 80,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isButtonEnabled ? _onNextPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isButtonEnabled ? AppColors.darkGreen : AppColors.txtGray,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: const Text(
            "다음",
            style: TextStyle(
              fontFamily: 'Paperlogy',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              "이메일 인증을 완료했어요.\n사용하실 비밀번호를 입력해주세요.",
              style: TextStyle(
                fontFamily: 'Paperlogy',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 28),

            _passwordField(
              hint: "비밀번호를 입력해주세요.",
              controller: _pwController,
            ),

            const SizedBox(height: 8),

            const Text(
              "비밀번호 재입력.",
              style: TextStyle(
                fontFamily: 'Paperlogy',
                fontSize: 14,
                color: Colors.white54,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 14),

            _passwordField(
              hint: "비밀번호를 다시 한번 입력해주세요.",
              controller: _pwConfirmController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      onChanged: (_) => _validate(),   // ← ★ 이 한 줄 중요
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Paperlogy',
          color: Colors.white54,
          fontSize: 15,
        ),
        filled: true,
        fillColor: const Color(0xFF555555),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: const TextStyle(
        fontFamily: 'Paperlogy',
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}

