import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';


//유저 프로필 저장
import 'package:cloud_firestore/cloud_firestore.dart';
//프로필 사진 업로드
import 'package:firebase_storage/firebase_storage.dart';
import 'package:teeklit/utils/fullscreen.dart';

import '../ui/core/themes/app_text.dart';
import '../ui/core/themes/colors.dart';
import 'auth_service.dart';
import 'signup_email_verify_screen.dart';
import 'signup_info.dart';
import 'package:go_router/go_router.dart';


class SignupProfileScreen extends StatefulWidget {
  final SignupInfo info;
  // 로그인 정보 저장

  const SignupProfileScreen({
    super.key,
    required this.info,
  });

  @override
  State<SignupProfileScreen> createState() => _SignupProfileScreenState();
}

///
/// 🔥 State 클래스: 상태(_localImagePath), setState(), build()는 여기서만 가능.
///
class _SignupProfileScreenState extends State<SignupProfileScreen> {
  String? _localImagePath;
  //  프로필 사진의 로컬 경로 저장.

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      _localImagePath = picked.path;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final nickname = widget.info.nickname ?? "";
    // 👉 nickname은 widget.info에서 가져와야 함

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

            /// 상단 텍스트
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "반가워요, $nickname님!\n",
                    style: AppText.H1.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  TextSpan(
                    text: "마지막으로 ",
                    style: AppText.H1.copyWith(
                      fontSize: 22,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  TextSpan(
                    text: "프로필 사진",
                    style: AppText.H1.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  TextSpan(
                    text: "을 올려볼까요?",
                    style: AppText.H1.copyWith(
                      fontSize: 22,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            /// 프로필 이미지 + 연필 아이콘
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  /// 프로필 원형
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFF4A4A4A),
                      backgroundImage: _localImagePath != null
                          ? FileImage(File(_localImagePath!))
                          : null,
                      child: _localImagePath == null
                          ? FractionallySizedBox(
                        widthFactor: 0.6,
                        heightFactor: 0.6,
                        child: Image.asset(
                          "assets/images/grey_check.png",
                          fit: BoxFit.cover,
                        ),
                      )
                          : null,
                    ),
                  ),

                  /// 연필 아이콘
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: GestureDetector(
                      onTap: _pickImage, // ← 연필 눌렀을 때 갤러리 열림!
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF7F5E6),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/pencil.png",
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 닉네임 표시
            Center(
              child: Text(
                nickname,
                style: AppText.Body1.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),

      /// 이메일 확인으로 넘기기 버튼
      bottomNavigationBar: SizedBox(
        height: 80,
        child: ElevatedButton(
            onPressed: () async {
              final info = widget.info.copyWith(
                profileImagePath: _localImagePath,
              );

              try {
                // 1) Firebase Auth 계정 생성
                final credential = await AuthService.instance.signUpWithEmail(
                  email: info.email,
                  password: info.password!,
                );

                final user = credential.user!;
                String? photoUrl;

                // 2) 프로필 이미지를 선택한 경우 → Firebase Storage 업로드
                if (info.profileImagePath != null) {
                  final file = File(info.profileImagePath!);

                  final storageRef = FirebaseStorage.instance
                      .ref()
                      .child('users')
                      .child(user.uid)
                      .child('profile.jpg');

                  await storageRef.putFile(file);
                  photoUrl = await storageRef.getDownloadURL();
                }

                // 3) Firestore users/{uid}에 계정 정보 저장
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .set({
                  'email': info.email,
                  'nickname': info.nickname,
                  'profileImage': photoUrl,
                  'createdAt': FieldValue.serverTimestamp(),
                  'isAdmin': false,
                  'blockUser': null,
                });

                // 4) 이메일 인증 메일 보내기
                await user.sendEmailVerification();

                // 🔥 4-1) 바로 로그아웃시키기 (중요)
                await FirebaseAuth.instance.signOut();

                if (!mounted) return;


                // 5) UI 알림 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("이메일 인증을 진행해주세요.")),
                );

                // 6) 로그인 화면으로 이동하거나 자동 로그인 처리
                context.push('/signup-email-verify', extra: info);


              } on FirebaseAuthException catch (e) {
                print("🔥 FirebaseAuthException code: ${e.code}");
                print("🔥 FirebaseAuthException message: ${e.message}");

                final msg = AuthService.instance.getErrorMessage(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg)),
                );
              }
            },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB1C39F),
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Text(
            "다음",
            style: AppText.Button.copyWith(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
