class UserModelTemp {
  final String uid;
  final String email;
  final String? nickname;
  final String? profileImage;

  UserModelTemp({
    required this.uid,
    required this.email,
    this.nickname,
    this.profileImage,
  });

  factory UserModelTemp.fromMap(String uid, Map<String, dynamic> data) {
    return UserModelTemp(
      uid: uid,
      email: data['email'] ?? '',
      nickname: data['nickname'],
      profileImage: data['profileImage'],
    );
  }
}
