import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teeklit/data/repositories/community_firebase_repository.dart';
import 'package:teeklit/data/repositories/user_firebase_repository.dart';
import 'package:teeklit/domain/model/community/comments.dart';
import 'package:teeklit/domain/model/community/modify_image.dart';
import 'package:teeklit/domain/model/community/posts.dart';
import 'package:teeklit/domain/model/user/user.dart';
import 'package:teeklit/login/signup_info.dart';
import 'package:teeklit/ui/community/imsi/fire_base_user.dart';

class CommunityViewModel extends ChangeNotifier {
  final CommunityFirebaseRepository _repo = CommunityFirebaseRepository();
  final UserFirebaseRepository _userRepo = UserFirebaseRepository();

  CommunityViewModel(){
    getCurrentUser();
  }

  late String myId;
  bool isAdmin = false;

  PostCategory mainCategory = PostCategory.popular;
  List<Posts> postList = [];

  late User postUserInfo;
  late Posts post;
  late String postId;
  late User commentUserInfo;
  List<Comments> commentList = [];
  List<(Comments, User)> commentAndUser = [];
  List<(Comments, User)> parentComments = [];
  Map<String, List<(Comments, User)>> childCommentsMap = {};
  bool likeButtonIsSelected = false;

  List<String> blockUserList = [];
  List<Posts> trendingPostList = [];

  int setPostcount = 20;
  bool hasMore = true;
  DocumentSnapshot? lastDoc;

  bool isLoading = false;


  /// user 받아오기
  Future<void> getCurrentUser() async{
    SignupInfo currentUser = await getUser();

    myId = currentUser.userId!;
    isAdmin = currentUser.isAdmin!;
  }

  /// main에서 게시글 선택 시, 게시글 id 저장
  Future<void> selectedPost(String selectedPostId) async {
    if (isLoading) return;
    isLoading = true;

    postId = selectedPostId;
    await loadPost();
    postUserInfo = await getUserInfo(post.userId);
    await getPostLikeUser();

    isLoading = false;
  }

  /// 처음 페이지 로딩 시, 20개만 로딩
  Future<void> firstLoadPosts() async {
    if (isLoading) return;
    isLoading = true;

    await getCurrentUser();

    postList.clear();

    await getBlockUserList();
    final (newPosts, newLastDoc, snapshotLength) = await _repo.loadPosts(
      limitCount: setPostcount,
      blockedUserList: blockUserList,
      category: mainCategory,
    );

    postList = newPosts;
    lastDoc = newLastDoc;

    hasMore = snapshotLength == setPostcount;

    isLoading = false;
    notifyListeners();
  }

  /// 스크롤 시 20개씩 추가 불러오기
  Future<void> loadMorePosts() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();

    // await getBlockUserList(); // 처음 가져온 후 추가 로딩인데, 처음 가져올 때 한번만 갱신하면 될듯?
    final (newPosts, newLastDoc, snapshotLength) = await _repo.loadPosts(
      limitCount: setPostcount,
      startAfter: lastDoc,
      blockedUserList: blockUserList,
      category: mainCategory,
    );

    postList.addAll(newPosts);
    lastDoc = newLastDoc;

    hasMore = snapshotLength == setPostcount;

    isLoading = false;
    notifyListeners();
  }

  /// 게시글 하나 불러오기
  Future<void> loadPost() async {
    post = await _repo.readOnePost(postId);
    await readComment();
  }

  /// 게시글 저장하기
  Future<void> addPost(
    String postTitle,
    String postContents,
    String category,
    List<File> images,
  ) async {
    if (isLoading) return;
    isLoading = true;

    final Posts newPost = Posts(
      postTitle: postTitle,
      postContents: postContents,
      category: category,
      createAt: DateTime.now(),
      userId: myId,
      imgUrls: await _repo.saveImages(images) ?? [],
      postView: 0,
      postLike: [],
      commentsCount: 0,
    );

    await _repo.addPost(newPost);

    isLoading = false;
    await firstLoadPosts();
  }

  /// 게시글 수정
  Future<void> modifyPost(
    String postTitle,
    String postContents,
    String category,
    List<ModifyImage> images,
  ) async {
    if (isLoading) return;
    isLoading = true;

    // 원래 저장되있는 사진(url)은 저장 안하고 따로 보관
    final List<String> oldImage = images
        .where((img) => img.url != null)
        .map((img) => img.url!)
        .toList();
    // 새로운 사진들
    final List<File> newImage = images
        .where((img) => img.file != null)
        .map((img) => img.file!)
        .toList();

    await _repo.modifyPost(
      post.copyWith(
        postTitle: postTitle,
        postContents: postContents,
        category: category,
        imgUrls: oldImage + (await _repo.saveImages(newImage) ?? []),
        updateAt: DateTime.now(),
      ),
      postId,
    );

    isLoading = false;
    mainCategory = PostCategory.popular;
  }

  /// 게시글 삭제
  Future<void> deletePost() async {
    await _repo.deletePost(postId);
    mainCategory = PostCategory.popular;
  }

  /// 게시글 좋아요 버튼 기능
  Future<void> tapLikeButton() async {
    if (isLoading) return;
    isLoading = true;

    if (likeButtonIsSelected) {
      await _repo.removeLike(postId, myId);
      likeButtonIsSelected = false;
    } else {
      await _repo.addLike(postId, myId);
      likeButtonIsSelected = true;
    }

    isLoading = false;
    notifyListeners();
  }

  /// 게시글 좋아요 누른 유저 리스트
  Future<void> getPostLikeUser() async {
    List<String> postLikeUserList = await _repo.getPostLikeUser(postId);
    if (postLikeUserList.contains(myId)) {
      likeButtonIsSelected = true;
    } else {
      likeButtonIsSelected = false;
    }
  }

  /// 댓글 작성
  Future<void> commentWrite(String comment, String? parentId) async {
    if (isLoading) return;
    isLoading = true;

    final Comments newComment = Comments(
      userId: myId,
      commentContents: comment,
      createAt: DateTime.now(),
      parentId: parentId,
    );

    await _repo.commentWrite(newComment, postId);
    await readComment();

    isLoading = false;
    notifyListeners();
  }

  /// 댓글 불러오기
  Future<void> readComment() async {
    commentList = await _repo.readComment(postId);

    commentAndUser = await Future.wait(
      commentList.map((comment) async {
        final user = await _userRepo.getUserInfo(comment.userId);
        return (comment, user);
      }),
    );

    organizeComments();
  }

  /// 댓글 부모 자식 전처리
  void organizeComments() {
    parentComments.clear();
    childCommentsMap.clear();

    parentComments = commentAndUser
        .where((comment) => comment.$1.parentId == null)
        .toList();

    for (var i in commentAndUser) {
      final parentId = i.$1.parentId;

      if (parentId != null) {
        if (childCommentsMap[parentId] == null) {
          childCommentsMap[parentId] = [];
        }
        childCommentsMap[parentId]!.add(i);
      }
    }
  }

  /// 댓글 갯수 반환
  Future<int> responseCommentCount(String postId) async {
    final List<Comments> getCommentList = await _repo.readComment(postId);
    return getCommentList.length;
  }

  /// 댓글 유저 불러오기
  Future<User> getUserInfo(String userId) async {
    return await _userRepo.getUserInfo(userId);
  }

  /// 댓글 시간 순 정렬 함수
  void commentSortByDate(String item) {
    final newList = List<(Comments, User)>.of(commentAndUser);

    if (item == SortStandard.recent.value) {
      newList.sort((a, b) => b.$1.createAt.compareTo(a.$1.createAt)); // 내림차순
    } else if (item == SortStandard.old.value) {
      newList.sort((a, b) => a.$1.createAt.compareTo(b.$1.createAt)); // 오름차순
    }

    commentAndUser = newList;
    organizeComments();

    notifyListeners();
  }

  /// 유저 차단
  Future<void> blockUser() async {
    await _userRepo.blockUser(myId, post.userId);
  }

  /// 차단 유저 목록 가져오기
  Future<void> getBlockUserList() async {
    blockUserList = await _userRepo.getBlockUserId(myId);
  }

  /// 게시글 숨기기
  Future<void> hidePost() async {
    await _repo.hidePost(postId);
  }

  /// 댓글 숨기기
  Future<void> hideComment(String commentId) async {
    if (isLoading) return;
    isLoading = true;

    await _repo.hideComment(postId, commentId);
    await readComment();

    isLoading = false;
    notifyListeners();
  }

  /// 댓글 삭제
  Future<void> deleteComment(String commentId) async {
    if (isLoading) return;
    isLoading = true;

    await _repo.deleteComment(postId, commentId);
    await readComment();

    isLoading = false;
    notifyListeners();
  }

  /// 메인에서 카테고리 선택하면 실행
  Future<void> changeCategory(PostCategory category) async{
    mainCategory = category;
    await firstLoadPosts();
  }

  /// 댓글 5개 이상인 게시글 리스트 가져오기 : 란 임시추가
  Future<List<TrendingPostWithCommentCount>> getTrendingPostList() async {
    trendingPostList = await _repo.getTrendingPosts();
    print('✓ 인기 게시글 조회 완료: ${trendingPostList.length}개');
    notifyListeners();

    /// 각 게시글의 댓글 개수를 조회
    final trendingPostWithCommentCountList = await Future.wait(
      trendingPostList.map((post) async {
        final commentCount = await responseCommentCount(post.postId!);
        return TrendingPostWithCommentCount(
          post: post,
          commentCount: commentCount,
        );
      }),
    );
    print('=== 최종 반환: ${trendingPostWithCommentCountList.length}개 ===');
    return trendingPostWithCommentCountList;
  }
}



class TrendingPostWithCommentCount {
  final Posts post;
  final int commentCount;

  TrendingPostWithCommentCount({
    required this.post,
    required this.commentCount,
  });
}
