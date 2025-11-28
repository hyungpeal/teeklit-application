import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _pwController = TextEditingController();
  final _confirmPwController = TextEditingController();
  bool _showPw = false;
  bool _showConfirm = false;
  bool _isLoading = false;

  final _auth = FirebaseAuth.instance;

  Future<bool?> _showDeleteConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '정말 탈퇴 하시겠어요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '탈퇴 선택 시, 계정은 삭제되며,\n복구되지 않습니다.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                /// 버튼들
                Column(
                  children: [
                    // 위: "탈퇴" (회색 버튼)
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF707070),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => context.pop(true),
                        child: const Text(
                          '탈퇴',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 아래: "계속 함께하기💪" (연두색 버튼)
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB6C89D), // 카드 그린이랑 맞춰도 됨
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => context.pop(false),
                        child: const Text(
                          '계속 함께하기💪🏻',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    final pw = _pwController.text.trim();
    final confirmPw = _confirmPwController.text.trim();

    if (pw.isEmpty || confirmPw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호를 모두 입력해주세요.')),
      );
      return;
    }
    if (pw != confirmPw) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    final confirm = await _showDeleteConfirmDialog(context);

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser!;
      final email = user.email!;

      // 1) 재인증
      final cred = EmailAuthProvider.credential(email: email, password: pw);
      await user.reauthenticateWithCredential(cred);

      final uid = user.uid;

      // 2) Firestore 유저 문서 삭제
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // 3) Storage 프로필 이미지 삭제 (있다면)
      final storageRef =
      FirebaseStorage.instance.ref().child('users/$uid/profile.jpg');
      try {
        await storageRef.delete();
      } catch (_) {
        // 없으면 무시
      }

      // 4) Firebase Auth 계정 삭제
      await user.delete();

      if (!mounted) return;

      // 5) 탈퇴 완료 화면으로 이동
      context.go('/delete-done');

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('탈퇴 실패: ${e.code}')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('알 수 없는 오류가 발생했습니다.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => context.pop(true),
        ),
        title: const Text(
          '탈퇴하기',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _deleteAccount,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.black)
              : const Text(
            '탈퇴하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '새싹랩님과의 이별인가요? 너무 아쉬워요.\n계정을 삭제하기 위해서 아래의 과정이 필요해요.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Text(
              '비밀번호 입력',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pwController,
              obscureText: !_showPw,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '비밀번호를 입력해주세요.',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPw ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white54,
                  ),
                  onPressed: () {
                    setState(() => _showPw = !_showPw);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '비밀번호 재입력',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPwController,
              obscureText: !_showConfirm,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '비밀번호를 다시 입력해주세요.',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirm ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white54,
                  ),
                  onPressed: () {
                    setState(() => _showConfirm = !_showConfirm);
                  },
                ),
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

class DeleteDoneScreen extends StatelessWidget {
  const DeleteDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ElevatedButton(
          onPressed: () {
            // 온보딩/첫 화면으로 이동
            context.go('/login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(),
          ),
          child: const Text(
            '처음으로',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Image.asset('assets/images/Union.png'),
            const SizedBox(height: 24),
            const Text(
              '탈퇴가 완료 되었어요.\n다음에 또 만나요!',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              '그동안 티클릿을.\n이용해 주셔서 감사합니다.',
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}