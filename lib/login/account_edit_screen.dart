import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teeklit/ui/core/themes/app_text.dart';

import '../../ui/core/themes/colors.dart';
import '../data/services/user_update_service.dart';

class AccountEditScreen extends StatefulWidget {
  const AccountEditScreen({super.key});

  @override
  State<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final nicknameController = TextEditingController();
  final currentPwController = TextEditingController();
  final newPwController = TextEditingController();

  String? _localImage;

  @override
  void dispose() {
    nicknameController.dispose();
    currentPwController.dispose();
    newPwController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _localImage = picked.path;
    });
  }

  Future<void> _updateNickname() async {
    try {
      await UserUpdateService.instance.updateNickname(
        nicknameController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("닉네임이 변경되었습니다.")),
      );
    } catch (e) {
      print("🔥 Nickname update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("닉네임 변경 실패: $e")),
      );
    }
  }

  Future<void> _updatePassword() async {
    final currentPw = currentPwController.text.trim();
    final newPw = newPwController.text.trim();

    if (currentPw.isEmpty || newPw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("현재 비밀번호와 새 비밀번호를 모두 입력해주세요.")),
      );
      return;
    }

    try {
      await UserUpdateService.instance.updatePassword(newPw, currentPw);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("비밀번호가 변경되었습니다. 다시 로그인해주세요.")),
      );
    } on FirebaseAuthException catch (e) {
      print("🔥 Password update Firebase error: ${e.code}, ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류: ${e.code}")),
      );
    } catch (e) {
      print("🔥 Password update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("비밀번호 변경 실패: $e")),
      );
    }
  }

  Future<void> _updateProfileImage() async {
    if (_localImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("변경할 이미지를 먼저 선택해주세요.")),
      );
      return;
    }

    try {
      final url = await UserUpdateService.instance.updateProfileImage(_localImage!);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("프로필 사진이 변경되었습니다.")),
      );
    } catch (e) {
      print("🔥 Profile image update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이미지 변경 실패: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text("계정 정보 수정"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 닉네임 변경
            Text("닉네임 변경", style: AppText.H2.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(
                hintText: "새 닉네임 입력",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _updateNickname,
              child: const Text("닉네임 변경"),
            ),

            const SizedBox(height: 30),

            // 비밀번호 변경
            Text("비밀번호 변경", style: AppText.H2.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            TextField(
              controller: currentPwController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "현재 비밀번호 입력",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: newPwController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "새 비밀번호 입력",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _updatePassword,
              child: const Text("비밀번호 변경"),
            ),

            const SizedBox(height: 30),

            // 프로필 이미지 변경
            Text("프로필 이미지 변경", style: AppText.H2.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  backgroundImage: _localImage != null ? FileImage(File(_localImage!)) : null,
                  child: _localImage == null
                      ? const Icon(Icons.camera_alt, size: 30)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _updateProfileImage,
              child: const Text("프로필 사진 변경"),
            ),
          ],
        ),
      ),
    );
  }
}
