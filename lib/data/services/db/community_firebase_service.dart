import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:teeklit/domain/model/community/comments.dart';
import 'package:teeklit/domain/model/community/posts.dart';

class CommunityFirebaseService {
  final String comments = 'comments';
  final String posts = 'posts';

  late final postRef = FirebaseFirestore.instance.collection(posts);
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  /// post add 게시글 추가
  Future<void> addPost(Posts post) async {
    await postRef.add(post.toJson());
  }

  /// 게시글 수정
  Future<void> modifyPost(Posts copyPost, String postId) async {
    await postRef.doc(postId).update(copyPost.toJson());
  }

  /// post one read 게시글 하나 읽기
  Future<Posts> readOnePosts(String postId) async {


    // 동기화
    final result = await FirebaseFirestore.instance.runTransaction((transaction) async{
      final documentRef = postRef.doc(postId);

      final postDoc = await transaction.get(documentRef);

      if(!postDoc.exists){
        throw Exception('게시글 존재하지 않음');
      }

      // 조회수
      final Posts post = Posts.fromJson(postDoc);
      final int viewCount = post.postView;

      // 조회수 업데이트
      transaction.update(documentRef, {'postView': viewCount + 1});

      // 반환은 갖고있는 게시글을 복사해 조회수 +1 한 객체
      return post.copyWith(postView: viewCount + 1);
    });

    return result;
  }

  /// post update 게시글 업데이트
  Future<void> updatePost(Posts post) async {
    await postRef.doc(post.postId).set(post.toJson());
  }

  /// post delete 게시글 삭제
  Future<void> deletePost(String postId) async {
    await postRef.doc(postId).delete();
  }

  /// save Image 사진 저장, Firebase Storage 기능
  Future<String> saveImage(File image) async {
    // ref
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('image')
        .child('community')
        .child('${DateTime.now().millisecondsSinceEpoch}');

    // 저장
    await storageRef.putFile(image);

    // 저장 경로 반환
    return storageRef.getDownloadURL();
  }

  /// 인기글 판별(댓글 5개 이상)
  Future<List<Posts>> popularPosts() async{

    final documentSnapshot = await postRef.where('commentsCount', isGreaterThanOrEqualTo: 5).limit(5).get();

    return documentSnapshot.docs.map((e) => Posts.fromJson(e)).toList();
  }

  // 무한 스크롤 백업
  /*  Future<(List<Posts>, DocumentSnapshot?)> loadPosts({DocumentSnapshot? startAfter, required int limitCount}) async {
    Query query = postRef
        .orderBy('createAt', descending: true)
        .limit(limitCount);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();

    final List<Posts> postList = snapshot.docs
        .map((e) => Posts.fromJson(e))
        .toList();
    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return (postList, lastDoc);
  }*/

  /// 무한 스크롤
  Future<(QuerySnapshot, DocumentSnapshot?)> loadPosts({
    DocumentSnapshot? startAfter,
    required int limitCount,
    required PostCategory category,
  }) async {
    Query query;

    query = switch(category){
      PostCategory.popular => postRef.where('commentsCount', isGreaterThanOrEqualTo: 5),

      PostCategory.free => postRef
          .where('isHided', isEqualTo: false)
          .where('category', isEqualTo: PostCategory.free.value)
          .orderBy('createAt', descending: true)
          .limit(limitCount),

      PostCategory.teekle => postRef
          .where('isHided', isEqualTo: false)
          .where('category', isEqualTo: PostCategory.teekle.value)
          .orderBy('createAt', descending: true)
          .limit(limitCount),

      PostCategory.info => postRef
          .where('isHided', isEqualTo: false)
          .where('category', isEqualTo: PostCategory.info.value)
          .orderBy('createAt', descending: true)
          .limit(limitCount),
    };

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();

    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return (snapshot, lastDoc);
  }

  /// 댓글 저장
  Future<void> commentWrite(Comments newComment, String postId) async {
    final DocumentReference postDocRef = postRef.doc(postId);

    await FirebaseFirestore.instance.runTransaction((transaction) async{
      DocumentSnapshot postDoc = await transaction.get(postDocRef);

      // 게시글이 없을 시 나오는 오류
      if(!postDoc.exists) {
        throw Exception('게시글 존재하지 않음');
      }


      DocumentReference commentsRef = postDocRef.collection(comments).doc();
      transaction.set(commentsRef, newComment.toJson());

      int commentsCount = (postDoc.data() as Map)['commentsCount'];
      transaction.update(postDocRef, {'commentsCount': commentsCount + 1});
    });

    // postRef.doc(postId).collection(comments).add(newComment.toJson());
  }

  /// 댓글 가져오기
  Future<List<Comments>> readComment(String postId) async {
    List<Comments> getComments = [];

    final documentSnapshot = await postRef
        .doc(postId)
        .collection(comments)
        .where('isHided', isEqualTo: false)
        .orderBy(
          'createAt',
        )
        .get();

    for (var i in documentSnapshot.docs) {
      getComments.add(Comments.fromJson(i));
    }

    return getComments;
  }

  /// 좋아요 추가
  Future<void> addLike(String postId, String userId) async {
    await postRef.doc(postId).update({
      'postLike': FieldValue.arrayUnion([userId]),
    });
  }

  /// 좋아요 제거
  Future<void> removeLike(String postId, String userId) async {
    await postRef.doc(postId).update({
      'postLike': FieldValue.arrayRemove([userId]),
    });
  }

  /// 좋아요 누른 사람들 목록 가져오기
  Future<List<String>> getPostLikeUser(String postId) async {
    final documentSnapshot = await postRef.doc(postId).get();

    final data = documentSnapshot.data();

    List<String> postLikeUserList = [];

    if (data != null) {
      postLikeUserList = List.from(data['postLike']);
    }

    return postLikeUserList;
  }

  /// 게시글 숨기기 기능
  Future<void> hidePost(String postId) async {
    await postRef.doc(postId).update({'isHided': true});
  }

  /// 댓글 숨기기 기능
  Future<void> hideComment(String postId, String commentId) async {
    await postRef.doc(postId).collection(comments).doc(commentId).update({
      'isHided': true,
    });
  }

  /// 댓글 삭제
  Future<void> deleteComment(String postId, String commentId) async {
    await postRef.doc(postId).collection(comments).doc(commentId).delete();
  }
}
