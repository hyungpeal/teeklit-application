import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();

  bool _step1Done = false;
  bool _isLoading = false;
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  final _auth = FirebaseAuth.instance;

  Future<void> _verifyCurrentPassword() async {
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser!;
      final email = user.email!;
      final cred = EmailAuthProvider.credential(
        email: email,
        password: _currentPwController.text.trim(),
      );
      await user.reauthenticateWithCredential(cred);

      setState(() {
        _step1Done = true;
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('현재 비밀번호가 올바르지 않습니다. (${e.code})')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _changePassword() async {
    final newPw = _newPwController.text.trim();
    final confirmPw = _confirmPwController.text.trim();

    if (newPw.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호는 6자 이상이어야 합니다.')),
      );
      return;
    }
    if (newPw != confirmPw) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.currentUser!.updatePassword(newPw);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 변경되었습니다.')),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호 변경 실패: ${e.code}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '현재 비밀번호',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _currentPwController,
          obscureText: !_showCurrent,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '현재 비밀번호를 입력해주세요.',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            suffixIcon: IconButton(
              icon: Icon(
                _showCurrent ? Icons.visibility_off : Icons.visibility,
                color: Colors.white54,
              ),
              onPressed: () {
                setState(() => _showCurrent = !_showCurrent);
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '새 비밀번호',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _newPwController,
          obscureText: !_showNew,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '새 비밀번호를 입력해주세요.',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            suffixIcon: IconButton(
              icon: Icon(
                _showNew ? Icons.visibility_off : Icons.visibility,
                color: Colors.white54,
              ),
              onPressed: () {
                setState(() => _showNew = !_showNew);
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
            hintText: '비밀번호를 다시 한 번 입력해주세요.',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonLabel = _step1Done ? '변경 완료' : '다음';
    final onPressed = _step1Done ? _changePassword : _verifyCurrentPassword;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '비밀번호 변경',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ElevatedButton(
          onPressed: _isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.black)
              : Text(
            buttonLabel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: _step1Done ? _buildStep2() : _buildStep1(),
      ),
    );
  }
}