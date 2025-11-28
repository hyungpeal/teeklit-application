import 'package:cloud_firestore/cloud_firestore.dart';

enum UserAuthor {
  client(value: '일반'),
  admin(value: '관리자');

  final String value;

  const UserAuthor({required this.value});
}

class User {
  final String? userId;
  final String email;
  final String? password;
  final String? nickname;
  final String? profileImage; // 로컬 파일 경로 (선택)
  final bool? isAdmin;
  final List<String>? blockUser;

  const User({
    required this.email,
    this.password,
    this.nickname,
    this.profileImage,
    this.userId,
    this.blockUser,
    this.isAdmin,
  });

  factory User.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      userId: doc.id,
      email: data['email'],
      nickname: data['nickname'],
      profileImage: data['profileImage'],
      isAdmin: data['isAdmin'],
    );
  }

  User copyWith({
    String? email,
    String? password,
    String? nickname,
    String? profileImage,
    List<String>? blockUser,
    bool? isAdmin,
  }) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      blockUser: blockUser ?? this.blockUser,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
