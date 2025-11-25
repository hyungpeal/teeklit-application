import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/providers/user_provider.dart';
import '../../core/themes/colors.dart';
import '../../core/themes/app_text.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  String? _localImage;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();

    final profile = context.read<UserProvider>().profile;

    _nicknameController.text = profile?.nickname ?? "";
    _currentImageUrl = profile?.profileImage;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _localImage = picked.path;
    });
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser!;
    String? imageUrl = _currentImageUrl;

    if (_localImage != null) {
      final file = File(_localImage!);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/profile.jpg');

      await storageRef.putFile(file);
      imageUrl = await storageRef.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'nickname': _nicknameController.text.trim(),
      'profileImage': imageUrl,
    });

    await context.read<UserProvider>().loadUserProfile();

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          '프로필 수정',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ElevatedButton(
          onPressed: _saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(),
          ),
          child: const Text(
            "저장하기",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),

            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.grey[700],
                    backgroundImage: _localImage != null
                        ? FileImage(File(_localImage!))
                        : (_currentImageUrl != null
                        ? NetworkImage(_currentImageUrl!)
                        : null) as ImageProvider<Object>?,
                    child: (_localImage == null && _currentImageUrl == null)
                        ? Image.asset(
                      'assets/images/default_profile.png',
                      width: 60,
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF7F5E6),
                        ),
                        child: const Icon(Icons.edit, size: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 32),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "닉네임",
                style: AppText.Body1.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _nicknameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
