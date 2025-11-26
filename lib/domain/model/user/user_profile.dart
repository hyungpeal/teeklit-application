class UserProfile {
  final String uid;
  final String email;
  final String nickname;
  final String? profileImage;

  UserProfile({
    required this.uid,
    required this.email,
    required this.nickname,
    this.profileImage,
  });

  factory UserProfile.fromJson(
      Map<String, dynamic> json,
      String uid,
      ) {
    return UserProfile(
      uid: uid,
      email: json['email'] ?? '',
      nickname: json['nickname'] ?? '',
      profileImage: json['profileImage'],
    );
  }
}