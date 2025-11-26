import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserUpdateService {
  static final instance = UserUpdateService._();
  UserUpdateService._();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> updateNickname(String nickname) async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(uid).update({
      'nickname': nickname,
    });
  }

  Future<void> updatePassword(String newPassword, String currentPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("로그인이 필요합니다.");

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<String?> updateProfileImage(String localPath) async {
    final uid = _auth.currentUser!.uid;
    final file = File(localPath);
    final ref = _storage.ref().child('users/$uid/profile.jpg');

    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    await _firestore.collection('users').doc(uid).update({
      'profileImage': url,
    });

    return url;
  }

  Future<void> updateUser({
    String? nickname,
    String? password,
    String? currentPassword,
    String? profileLocalPath,
  }) async {
    if (nickname != null) await updateNickname(nickname);

    if (password != null) {
      if (currentPassword == null) {
        throw Exception("현재 비밀번호가 필요합니다.");
      }
      await updatePassword(password, currentPassword);
    }

    if (profileLocalPath != null) {
      await updateProfileImage(profileLocalPath);
    }
  }
}
