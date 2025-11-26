// lib/ui/mypage/edit_profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/services/user_update_service.dart';
import '../core/themes/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();

  String? _localImagePath; // 새로 선택한 이미지 경로
  String? _originalNickname;
  String? _originalProfileImageUrl;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    _originalNickname = doc['nickname'];
    _originalProfileImageUrl = doc['profileImage'];

    _nicknameController.text = _originalNickname ?? '';

    setState(() => _loading = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _localImagePath = picked.path);
    }
  }

  void _onSavePressed() async {
    if (_loading) return;

    final newNickname = _nicknameController.text.trim();
    final newPassword = _passwordController.text.trim();
    final confirm = _passwordConfirmController.text.trim();
    final currentPw = _currentPasswordController.text.trim();

    // 비밀번호 검증
    if (newPassword.isNotEmpty) {
      if (newPassword != confirm) {
        _show("비밀번호가 일치하지 않아요.");
        return;
      }
      if (currentPw.isEmpty) {
        _show("현재 비밀번호를 입력해야 해요.");
        return;
      }
    }

    try {
      await UserUpdateService.instance.updateUser(
        nickname: newNickname.isNotEmpty && newNickname != _originalNickname
            ? newNickname
            : null,
        password: newPassword.isNotEmpty ? newPassword : null,
        currentPassword: currentPw.isNotEmpty ? currentPw : null,
        profileLocalPath: _localImagePath,
      );

      if (!mounted) return;

      _show("정보수정 완료!");
      Navigator.pop(context);

    } catch (e) {
      _show("오류 발생: $e");
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      bottomNavigationBar: SizedBox(
        height: 80,
        child: ElevatedButton(
          onPressed: _onSavePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8C8C8C),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: const Text(
            "저장하기",
            style: TextStyle(
              fontFamily: 'Paperlogy',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 12),
          const Text(
            "프로필 정보를 수정하세요.",
            style: TextStyle(
              fontFamily: 'Paperlogy',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 28),

          /// 프로필 이미지
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xFF4A4A4A),
                backgroundImage: _localImagePath != null
                    ? FileImage(File(_localImagePath!))
                    : (_originalProfileImageUrl != null
                    ? NetworkImage(_originalProfileImageUrl!)
                    : null) as ImageProvider?,
                child: (_localImagePath == null && _originalProfileImageUrl == null)
                    ? const Icon(Icons.camera_alt, size: 32, color: Colors.white70)
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 32),

          _field("닉네임", "새 닉네임 입력", _nicknameController),

          const SizedBox(height: 18),
          _field("새 비밀번호", "새 비밀번호 입력", _passwordController, obscure: true),

          const SizedBox(height: 12),
          _field("비밀번호 재입력", "비밀번호 확인", _passwordConfirmController, obscure: true),

          const SizedBox(height: 18),
          _field("현재 비밀번호", "기존 비밀번호 입력 (비번 변경 시 필수)", _currentPasswordController, obscure: true),
        ],
      ),
    );
  }

  Widget _field(String label, String hint, TextEditingController c, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Paperlogy',
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: c,
          obscureText: obscure,
          style: const TextStyle(
            fontFamily: 'Paperlogy',
            fontSize: 16,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Paperlogy',
              color: Colors.white54,
            ),
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
    );
  }
}
