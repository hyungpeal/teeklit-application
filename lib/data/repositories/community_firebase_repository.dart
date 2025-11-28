import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teeklit/data/services/db/community_firebase_service.dart';
import 'package:teeklit/domain/model/community/comments.dart';
import 'package:teeklit/domain/model/community/posts.dart';

class CommunityFirebaseRepository {
  // 커뮤니티에서 사용하는 firestore service
  final CommunityFirebaseService _communityService = CommunityFirebaseService();

  Future<void> addPost(Posts post) {
    return _communityService.addPost(post);
  }

  /// 게시글 전체 불러오기(무한 스크롤)
  Future<(List<Posts>, DocumentSnapshot?, int)> loadPosts({
    DocumentSnapshot? startAfter,
    required int limitCount,
    required List<String> blockedUserList,
    required PostCategory category,
  }) async {
    final (snapshot, lastDoc) = await _communityService.loadPosts(
      startAfter: startAfter,
      limitCount: limitCount,
      category: category,
    );

    return (
      snapshot.docs
          .map((doc) => Posts.fromJson(doc))
          .where((post) => !blockedUserList.contains(post.userId))
          .toList(),
      lastDoc,
      snapshot.docs.length,
    );
  }

  /// 게시글 상세보기
  Future<Posts> readOnePost(String postId) {
    return _communityService.readOnePosts(postId);
  }

  /// 이미지 저장
  Future<List<String>?> saveImages(List<File>? images) async {
    if (images == null) {
      return null;
    }

    // 경로 저장할 list
    final List<String> pathList = [];

    // list 내에서 하나씩 저장
    for (File image in images) {
      String imageUrl = await _communityService.saveImage(image);

      pathList.add(imageUrl);
    }

    return pathList;
  }

  Future<void> commentWrite(Comments newComment, String postId) async {
    _communityService.commentWrite(newComment, postId);
  }

  /// 댓글 필터링 하기
  Future<List<Comments>> readComment(String postId) async {
    return _communityService.readComment(postId);
  }

  Future<void> addLike(String postId, String userId) async {
    return _communityService.addLike(postId, userId);
  }

  Future<void> removeLike(String postId, String userId) async {
    return _communityService.removeLike(postId, userId);
  }

  Future<List<String>> getPostLikeUser(String postId) async {
    return _communityService.getPostLikeUser(postId);
  }

  Future<void> hidePost(String postId) async{
    return _communityService.hidePost(postId);
  }

  Future<void> hideComment(String postId, String commentId) {
    return _communityService.hideComment(postId, commentId);
  }

  Future<void> modifyPost(Posts copyPost, String postId) async {
    _communityService.modifyPost(copyPost, postId);
  }

  Future<void> deleteComment(String postId, String commentId) async {
    _communityService.deleteComment(postId, commentId);
  }

  Future<void> deletePost(String postId) async{
    _communityService.deletePost(postId);
  }
}
