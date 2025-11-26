

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teeklit/domain/model/community/block_user.dart';
import 'package:teeklit/domain/model/user/user.dart';

/// 임시 user service
class UserFirebaseService {
  final userRef = FirebaseFirestore.instance.collection('users');

  final String blockUser = 'blockUser';

  /// userInfo 불러오기
  Future<User> getUserInfo(String userId) async{
    final documentSnapshot = await userRef.doc(userId).get();
    
    return User.fromJson(documentSnapshot);
  }
  
  /// 유저 차단하기
  Future<void> addBlockUser(String myId, BlockUser targetUser) async{
    await userRef.doc(myId).collection(blockUser).doc(targetUser.blockedUserId).set(targetUser.toJson());
  }

  /// 유저 차단 해제
  Future<void> removeBlockUser(String myId, BlockUser targetUser) async{
    await userRef.doc(myId).collection(blockUser).doc(targetUser.blockedUserId).delete();
  }
  
  /// 차단 유저 목록 가져오기
  Future<List<String>> getBlockedUserId(String userId) async{
    final documentSnapshot = await userRef.doc(userId).collection(blockUser).get();

    return documentSnapshot.docs.map((doc) => doc.id).toList();
  }
}