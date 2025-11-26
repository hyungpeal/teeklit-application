import 'package:teeklit/data/services/db/user_firebase_service.dart';
import 'package:teeklit/domain/model/community/block_user.dart';
import 'package:teeklit/domain/model/user/user.dart';

class UserFirebaseRepository {
  final UserFirebaseService _userFirebaseService = UserFirebaseService();

  Future<User> getUserInfo(String userId) async{
    return _userFirebaseService.getUserInfo(userId);
  }

  Future<void> blockUser(String myId,String targetId) async{
    BlockUser targetUser = BlockUser(blockedUserId: targetId, createAt: DateTime.now());

    _userFirebaseService.addBlockUser(myId, targetUser);
  }

  Future<List<String>> getBlockUserId(String userId) async{
    return _userFirebaseService.getBlockedUserId(userId);
  }
}