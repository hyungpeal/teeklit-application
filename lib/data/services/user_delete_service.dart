// lib/data/services/user_delete_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserDeleteService {
  static final instance = UserDeleteService._();
  UserDeleteService._();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// 🔥 회원 탈퇴 (Auth + Firestore + Storage)
  Future<void> deleteAccount({required String currentPassword}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("로그인이 필요합니다.");

    // 1) 🔐 재인증
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);

    final uid = user.uid;

    // 2) Firestore user document 삭제
    await _firestore.collection('users').doc(uid).delete();

    // 3) Storage 프로필 이미지 삭제 (예외 발생해도 탈퇴 계속 진행)
    try {
      final ref = _storage.ref().child('users/$uid/profile.jpg');
      await ref.delete();
    } catch (_) {}

    // 4) Firebase Auth 계정 삭제
    await user.delete();
  }
}
