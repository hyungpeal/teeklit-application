import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/user_delete_service.dart';
import '../core/themes/colors.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _currentPwController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _currentPwController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final currentPw = _currentPwController.text.trim();

    if (currentPw.isEmpty) {
      _show("현재 비밀번호를 입력해주세요.");
      return;
    }

    setState(() => _loading = true);

    try {
      await UserDeleteService.instance.deleteAccount(currentPassword: currentPw);

      if (!mounted) return;
      _show("계정이 삭제되었습니다.");

      /// 계정 삭제 후 로그인 화면으로 이동
      context.go('/login');

    } catch (e) {
      _show("탈퇴 실패: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _show(String msg) {
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
          icon: const Icon(Icons.chevron_left, color: Colors.white70),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "회원 탈퇴",
          style: TextStyle(
            fontFamily: 'Paperlogy',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),

      bottomNavigationBar: SizedBox(
        height: 80,
        child: ElevatedButton(
          onPressed: _loading ? null : _delete,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          ),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            "정말 탈퇴할래요",
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
            const SizedBox(height: 26),

            const Text(
              "계정을 삭제하려면\n현재 비밀번호를 입력해주세요.",
              style: TextStyle(
                fontFamily: 'Paperlogy',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: _currentPwController,
              obscureText: true,
              style: const TextStyle(
                fontFamily: 'Paperlogy',
                fontSize: 16,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "현재 비밀번호",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF555555),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
