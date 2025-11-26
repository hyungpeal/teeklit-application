import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../domain/model/user/user_profile.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProfile? _profile;
  bool _isLoading = false;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _auth.currentUser != null;

  UserProvider() {
    // 로그인/로그아웃 상태 바뀔 때마다 Firestore 프로필 다시 로드
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        _profile = null;
        notifyListeners();
      } else {
        await loadUserProfile();
      }
    });
  }

  Future<void> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _userRepository.getCurrentUserProfile();
    } catch (e) {
      print('유저 프로필 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
