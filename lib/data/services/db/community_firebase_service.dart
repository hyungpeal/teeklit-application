import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:teeklit/domain/model/community/comments.dart';
import 'package:teeklit/domain/model/community/posts.dart';

class CommunityFirebaseService {
  final postRef = FirebaseFirestore.instance.collection('posts');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// post add 게시글 추가
  Future<void> addPost(Posts post) async {
    await postRef.add(post.toJson());
  }

  /// post one read 게시글 하나 읽기
  Future<Posts> readOnePosts(String postId) async {
    final documentSnapshot = await postRef.doc(postId).get();

    return Posts.fromJson(documentSnapshot);
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
  Future<String> saveImage(File image, String imageName) async {
    // ref
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('image')
        .child('community')
        .child('${DateTime.now().millisecondsSinceEpoch}_$imageName');

    // 저장
    await storageRef.putFile(image);

    // 저장 경로 반환
    return storageRef.getDownloadURL();
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
  Future<(QuerySnapshot, DocumentSnapshot?)> loadPosts({DocumentSnapshot? startAfter, required int limitCount}) async {
    Query query = postRef
        .where('isHided', isEqualTo: false).orderBy('createAt', descending: true)
        .limit(limitCount);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();

    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return (snapshot, lastDoc);
  }

  /// 댓글 저장
  void commentWrite(Comments newComment, String postId) async{
    postRef.doc(postId).collection('comment').add(newComment.toJson());
  }

  /// 댓글 가져오기
  Future<List<Comments>> readComment(String postId) async {
    List<Comments> getComments = [];

    final documentSnapshot = await postRef.doc(postId).collection('comment').where('isHided', isEqualTo: false).orderBy('createAt',).get();

    for(var i in documentSnapshot.docs){
      getComments.add(Comments.fromJson(i));
    }

    return getComments;
  }

  /// 좋아요 추가
  Future<void> addLike(String postId, String userId) async{
    await postRef.doc(postId).update({'postLike':FieldValue.arrayUnion([userId])});
  }

  /// 좋아요 제거
  Future<void> removeLike(String postId, String userId) async {
    await postRef.doc(postId).update({'postLike':FieldValue.arrayRemove([userId])});
  }

  /// 좋아요 누른 사람들 목록 가져오기
  Future<List<String>> getPostLikeUser(String postId) async {
    final documentSnapshot = await postRef.doc(postId).get();

    final data = documentSnapshot.data();

    List<String> postLikeUserList = [];

    if(data != null){
      postLikeUserList = List.from(data['postLike']);
    }

    return postLikeUserList;
  }
  
  /// 게시글 숨기기 기능
  Future<void> hidePost(String postId) async{
    await postRef.doc(postId).update({'isHided': true});
  }

  /// 댓글 숨기기 기능 TODO 댓글 받아오는거 필터링
  Future<void> hideComment(String postId,String commentId) async{
    await postRef .doc(postId).collection('comments').doc(commentId).update({'isHided': true});
  }
}
