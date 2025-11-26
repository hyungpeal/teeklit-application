import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class HomeTempPage extends StatelessWidget {
  const HomeTempPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("메인 화면", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// 🔥 프로필 편집
          ElevatedButton(
            onPressed: () {
              context.push('/profile-image-edit');
            },
            child: const Text("프로필 편집"),
          ),

          const SizedBox(height: 20),

          /// 🔥 비밀번호 변경
          ElevatedButton(
            onPressed: () {
              context.push('/password-edit');
            },
            child: const Text("비밀번호 변경"),
          ),

          const SizedBox(height: 40),

          /// 🔥 강제 로그아웃
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("로그아웃 완료")),
              );

              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("강제 로그아웃"),
          ),

          const SizedBox(height: 40),

          /// 🔥 회원 탈퇴하기
          ElevatedButton(
            onPressed: () {
              context.push('/delete-account');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text("회원 탈퇴하기"),
          ),
        ],
      ),
    );
  }
}

