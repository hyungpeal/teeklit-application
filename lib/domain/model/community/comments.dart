import 'package:cloud_firestore/cloud_firestore.dart';

enum SortStandard {
  recent(value: '최신순'),
  old(value: '등록순');

  final String value;

  const SortStandard({required this.value});
}

class Comments {
  final String? commentId;
  final String userId;
  final String commentContents;
  final DateTime createAt;
  final String? parentId;
  final List<String>? commentLike;

  final bool isHided = false;

  Comments({
    this.commentId,
    required this.userId,
    required  this.commentContents,
    required this.createAt,
    this.parentId,
    this.commentLike,
  });

  factory Comments.fromJson(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;

    final Timestamp ts = data['createAt'];

    return Comments(
      commentId: doc.id,
      userId: data['userId'],
      commentContents: data['commentContents'],
      createAt: DateTime.parse(ts.toDate().toString()),
      parentId: data['parentId'],
      commentLike: data['commentLike'],
    );
  }

  Map<String, dynamic> toJson() {
    return{
      'userId': userId,
      'commentContents': commentContents,
      'createAt': createAt,
      'parentId': parentId,
      'commentLike': commentLike,
      'isHided': false,
    };
  }
}
