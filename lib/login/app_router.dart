import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/login/signup_info.dart';
import 'package:teeklit/login/terms/terms_bottom_sheet.dart';

// Onboarding
import 'package:teeklit/onboarding/onboarding_screen.dart';

// Login
import 'package:teeklit/login/login_screen.dart';

// Home (필요하면 유지, 지금은 optional)
import 'package:teeklit/login/home_temp.dart';

import 'package:teeklit/login/signup_email.dart';
import 'package:teeklit/login/signup_email_verify_screen.dart';
import 'package:teeklit/login/signup_nickname.dart';
import 'package:teeklit/login/signup_password_screen.dart';
import 'package:teeklit/login/signup_profile_screen.dart';
import 'package:teeklit/login/signup_terms_screen.dart';
import '../ui/mypage/delete_account_screen.dart';

//찾기
import 'find_account_screen.dart';
import 'package:teeklit/login/account/password_edit.dart';
import 'package:teeklit/login/account/profile_edit.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [

    // 온보딩 첫 화면
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // 로그인 화면
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // 홈 화면 (테스트 용)
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeTempPage(),
    ),

    // -----------------------------
    // 🔻 아래 signup 관련 라우트는 지금 다 막아둠 🔻
    // 필요 파라미터(email, info 등) 구조 정리 후 다시 활성화
    // -----------------------------


    GoRoute(
      path: '/signup-email',
      builder: (context, state) => const SignupEmailScreen(),
    ),
// Verify
    GoRoute(
      path: '/signup-email-verify',
      builder: (context, state) {
        final info = state.extra as SignupInfo;
        return SignupEmailVerifyScreen(info: info);
      },
    ),

// Password
    GoRoute(
      path: '/signup-password',
      builder: (context, state) {
        final info = state.extra as SignupInfo;
        return SignupPasswordScreen(info: info);
      },
    ),

// Nickname
    GoRoute(
      path: '/signup-nickname',
      builder: (context, state) {
        final info = state.extra as SignupInfo;
        return SignupNicknameScreen(info: info);
      },
    ),

// Profile
    GoRoute(
      path: '/signup-profile',
      builder: (context, state) {
        final info = state.extra as SignupInfo;
        return SignupProfileScreen(info: info);
      },
    ),

// Terms
    GoRoute(
      path: '/signup-terms',
      builder: (context, state) => const SignupTermsScreen(),
    ),

    //아이디 찾기
    GoRoute(
      path: '/find-account',
      builder: (context, state) => const FindAccountScreen(),
    ),


    GoRoute(
      path: '/password-edit',
      builder: (context, state) => const PasswordEditScreen(),
    ),

    GoRoute(
      path: '/profile-image-edit',
      builder: (context, state) => const ProfileEditScreen(),
    ),

    //회원탈퇴
    GoRoute(
      path: '/delete-account',
      builder: (context, state) => const DeleteAccountScreen(),
    ),


  ],
);
