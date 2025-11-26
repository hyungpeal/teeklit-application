import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/ui/core/themes/app_text.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import '../../data/services/user_update_service.dart';

class PasswordEditScreen extends StatefulWidget {
  const PasswordEditScreen({super.key});

  @override
  State<PasswordEditScreen> createState() => _PasswordEditScreenState();
}

class _PasswordEditScreenState extends State<PasswordEditScreen> {
  final currentPw = TextEditingController();
  final newPw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "변경할 비밀번호를 입력해주세요",
              style: AppText.H1.copyWith(
                fontSize: 20,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 40),

            _pwField("현재 비밀번호", currentPw),
            const SizedBox(height: 16),
            _pwField("새 비밀번호", newPw),
          ],
        ),
      ),

      bottomNavigationBar: SizedBox(
        height: 80,
        child: ElevatedButton(
          onPressed: () async {
            if (currentPw.text.isEmpty || newPw.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("두 비밀번호를 모두 입력해주세요.")),
              );
              return;
            }

            try {
              await UserUpdateService.instance.updatePassword(
                newPw.text.trim(),
                currentPw.text.trim(),
              );

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("비밀번호가 변경되었습니다.")),
              );
              context.pop();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("오류: $e")),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB1C39F),
            foregroundColor: Colors.black,
          ),
          child: Text("변경하기",
              style: AppText.Button.copyWith(fontSize: 18, color: Colors.black)),
        ),
      ),
    );
  }

  Widget _pwField(String label, TextEditingController c) {
    return TextField(
      controller: c,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF4A4A4A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

