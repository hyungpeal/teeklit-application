import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../data/services/user_update_service.dart';
import '../../ui/core/themes/app_text.dart';
import '../../ui/core/themes/colors.dart';

//초기화
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user_model_temp.dart'; // 네가 만든 파일 경로


class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  String? _localPath;
  final _nicknameController = TextEditingController();

  bool get isButtonEnabled =>
      (_nicknameController.text.trim().isNotEmpty || _localPath != null);
  UserModelTemp? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() => setState(() {}));
    _loadUser(); // 🔥 추가
  }
  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = doc.data();
    if (data != null) {
      _user = UserModelTemp.fromMap(uid, data);

      _nicknameController.text = _user?.nickname ?? '';

      // 프로필 이미지 URL 있으면 avatar에서 사용하도록 localPath는 null 유지
    }

    setState(() => _isLoading = false);
  }


  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _localPath = picked.path;
      });
    }
  }

  Future<void> _onSave() async {
    final nickname = _nicknameController.text.trim();

    try {
      await UserUpdateService.instance.updateUser(
        nickname: nickname.isNotEmpty ? nickname : null,
        profileLocalPath: _localPath,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("수정이 완료되었습니다.")),
      );

      context.go('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류 발생: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.chevron_left, color: AppColors.strokeGray, size: 28),
        ),
        title: Text(
          "프로필 수정",
          style: AppText.H2.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),

      bottomNavigationBar: SizedBox(
        height: 80,
        child: ElevatedButton(
          onPressed: isButtonEnabled ? _onSave : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnabled
                ? AppColors.darkGreen
                : AppColors.txtGray,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Text(
            "저장하기",
            style:
            AppText.Button.copyWith(fontSize: 18, color: Colors.white),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            /// 프로필 이미지 + 연필 버튼
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF4A4A4A),
                    backgroundImage: _localPath != null
                        ? FileImage(File(_localPath!))
                        : (_user?.profileImage != null
                        ? NetworkImage(_user!.profileImage!)
                        : null),
                    child: _localPath == null
                        ? const Icon(Icons.camera_alt,
                        size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF7F5E6),
                      ),
                      child: const Center(
                        child: Icon(Icons.edit, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// 닉네임 입력
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "닉네임",
                style: AppText.Body1.copyWith(
                  color: AppColors.txtLight,
                ),
              ),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: _nicknameController,
              style: AppText.Body1.copyWith(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "닉네임을 입력하세요",
                hintStyle: AppText.Body1.copyWith(color: AppColors.txtGray),
                filled: true,
                fillColor: const Color(0xFF4A4A4A),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
