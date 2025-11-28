import 'package:cloud_firestore/cloud_firestore.dart';

class SignupInfo {
  final String? userId;
  final String email;
  final String? password;
  final String? nickname;
  final String? profileImagePath; // 로컬 파일 경로 (선택)
  final bool? isAdmin;
  final List<String>? blockUser;

  const SignupInfo({
    required this.email,
    this.password,
    this.nickname,
    this.profileImagePath,
    this.userId,
    this.blockUser,
    this.isAdmin,
  });

  factory SignupInfo.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SignupInfo(
      userId: doc.id,
      email: data['email'],
      nickname: data['nickname'],
      profileImagePath: data['profileImagePath'],
      isAdmin: data['isAdmin'],
    );
  }

  SignupInfo copyWith({
    String? email,
    String? password,
    String? nickname,
    String? profileImagePath,
    List<String>? blockUser,
    bool? isAdmin,
  }) {
    return SignupInfo(
      email: email ?? this.email,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      blockUser: blockUser ?? this.blockUser,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
