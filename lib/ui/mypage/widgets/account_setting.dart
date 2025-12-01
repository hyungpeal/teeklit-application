import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/utils/fullscreen.dart';
import '../../../login/auth_service.dart';
import 'change_password.dart';
import 'delete_account.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {

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

  Future<void> _confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '로그아웃',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '정말 로그아웃 하시겠어요? 🥺',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              '닫기',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),   // ✔ result=true 반환
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: Colors.black,
            ),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );

    if (result == true) {
      // ✔ 실제 Firebase 로그아웃
      await AuthService.instance.signOut();

      if (context.mounted) {
        // ✔ 로그인 화면으로 스택 전체 초기화 후 이동
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          '계정 설정',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 16),

          // 비밀번호 변경
          _AccountItem(
            title: '비밀번호 변경',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordScreen(),
                ),
              );
            },
          ),

          // 로그아웃
          _AccountItem(
            title: '로그아웃',
            onTap: () => _confirmLogout(context),
          ),

          // 탈퇴하기
          _AccountItem(
            title: '탈퇴하기',
            onTap: () => context.go('/delete-account'),
          ),
        ],
      ),
    );
  }
}

class _AccountItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _AccountItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
