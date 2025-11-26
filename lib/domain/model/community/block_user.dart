import 'package:cloud_firestore/cloud_firestore.dart';

class BlockUser {
  final String blockedUserId;
  final DateTime createAt;

  BlockUser({
    required this.blockedUserId,
    required this.createAt,
  });

  factory BlockUser.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final Timestamp ts = data['createAt'];

    return BlockUser(
      blockedUserId: data['blockedUserId'],
      createAt: DateTime.parse(ts.toDate().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blockedUserId': blockedUserId,
      'createAt': createAt,
    };
  }
}