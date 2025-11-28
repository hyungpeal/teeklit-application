import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teeklit/domain/model/community/comments.dart';

enum PostCategory {
  popular(value: '인기'),
  teekle(value: '티클'),
  free(value: '자유게시판'),
  info(value: '정보');
  
  final String value;

  const PostCategory({required this.value});
}

// 게시글 식별값은 doc id를 사용.
class Posts {
  final String? postId; // 게시글 식별값
  final String postTitle; // 게시글 제목
  final String postContents; // 게시글 내용
  final String category; // 게시글 카테고리
  final int postView; // 조회수
  final List<String> imgUrls; // 이미지 링크들
  final String? teekleId; // 티클 ID
  final DateTime createAt; // 게시글 생성 날짜
  final DateTime? updateAt; // 게시글 마지막 수정 날짜
  final List<String> postLike; // 좋아요 누른 사람들
  final String userId; // 게시글 작성자 UID
  final List<Comments>? comment; // 댓글
  final int commentsCount; // 댓글 개수
  
  final bool isHided = false;

  Posts({
    this.postId,
    required this.postTitle,
    required this.postContents,
    required this.category,
    required this.postView,
    required this.imgUrls,
    this.teekleId,
    required this.createAt,
    this.updateAt,
    required this.postLike,
    required this.userId,
    this.comment,
    required this.commentsCount,
  });

  /// db에 json 형태로 저장되있는 값들을 Posts 클래스 형태로 변환 후 반환
  factory Posts.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final Timestamp create = data['createAt'];
    final Timestamp? update = data['updateAt'];

    return Posts(
      postId: doc.id,
      postTitle: data['postTitle'],
      postContents: data['postContents'],
      category: data['category'],
      postView: data['postView'],
      imgUrls: List<String>.from(data['imgUrls']),
      teekleId: data['teekleId'],
      createAt: create.toDate(),
      updateAt: update?.toDate(), // 처음 저장될땐 null로 저장되고, 수정해야지 timestamp가 저장되는데 null 체크를 안해서 오류가 났음
      postLike: List.from(data['postLike']),
      userId: data['userId'],
      comment: data['comment'],
      commentsCount: data['commentsCount'],
    );
  }

  /// db에 저장하기 위해 Posts 클래스로 받은 값들을 json 형태로 만들어서 반환
  Map<String, dynamic> toJson() {
    return {
      'postTitle': postTitle,
      'postContents': postContents,
      'category': category,
      'imgUrls': imgUrls,
      'teekleId': teekleId,
      'createAt': createAt,
      'updateAt': updateAt,
      'postLike': postLike,
      'userId': userId,
      'comment': comment,
      'postView': postView,
      'isHided': false,
      'commentsCount': commentsCount
    };
  }

  Posts copyWith({
    String? postId,
    String? postTitle,
    String? postContents,
    String? category,
    int? postView,
    List<String>? imgUrls,
    String? teekleId,
    DateTime? createAt,
    DateTime? updateAt,
    List<String>? postLike,
    String? userId,
    List<Comments>? comment,
    bool? isHided,
  }){
    return Posts(
      postId : postId ?? this.postId,
      postTitle : postTitle ?? this.postTitle,
      postContents : postContents ?? this.postContents,
      category : category ?? this.category,
      postView : postView ?? this.postView,
      imgUrls : imgUrls ?? this.imgUrls,
      teekleId : teekleId ?? this.teekleId,
      createAt : createAt ?? this.createAt,
      updateAt : updateAt ?? this.updateAt,
      postLike : postLike ?? this.postLike,
      userId : userId ?? this.userId,
      comment : comment ?? this.comment,
      commentsCount: commentsCount,
    );
  }
}
