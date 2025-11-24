import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Onboarding
import 'package:teeklit/onboarding/onboarding_screen.dart';

// Login
import 'package:teeklit/login/login_screen.dart';

// Home (필요하면 유지, 지금은 optional)
import 'package:teeklit/login/home_temp.dart';

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

    /*
    GoRoute(
      path: '/signup-email',
      builder: (context, state) => const SignupEmail(),
    ),
    GoRoute(
      path: '/signup-email-verify',
      builder: (context, state) => const SignupEmailVerifyScreen(),
    ),
    GoRoute(
      path: '/signup-password',
      builder: (context, state) => const SignupPasswordScreen(),
    ),
    GoRoute(
      path: '/signup-nickname',
      builder: (context, state) => const SignupNickname(),
    ),
    GoRoute(
      path: '/signup-profile',
      builder: (context, state) => const SignupProfileScreen(),
    ),
    GoRoute(
      path: '/signup-terms',
      builder: (context, state) => const SignupTermsScreen(),
    ),
    */

  ],
);
