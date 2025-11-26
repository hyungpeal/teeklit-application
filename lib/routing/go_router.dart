import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/login/account/password_edit.dart';
import 'package:teeklit/login/find_account_screen.dart';
import 'package:teeklit/login/login_screen.dart';
import 'package:teeklit/login/signup_email.dart';
import 'package:teeklit/login/signup_email_verify_screen.dart';
import 'package:teeklit/login/signup_info.dart';
import 'package:teeklit/login/signup_nickname.dart';
import 'package:teeklit/login/signup_password_screen.dart';
import 'package:teeklit/login/signup_profile_screen.dart';
import 'package:teeklit/login/signup_terms_screen.dart';
import 'package:teeklit/onboarding/onboarding_screen.dart';
import 'package:teeklit/ui/community/community_main_page.dart';
import 'package:teeklit/ui/community/community_post_view_page.dart';
import 'package:teeklit/ui/community/community_post_write_page.dart';
import 'package:teeklit/ui/home/home_page.dart';
import 'package:teeklit/ui/home/navigation_view.dart';
import 'package:teeklit/domain/model/enums.dart';
import 'package:teeklit/ui/mypage/delete_account_screen.dart';
import 'package:teeklit/ui/mypage/widgets/account_setting.dart';
import 'package:teeklit/ui/mypage/widgets/alert_setting.dart';
import 'package:teeklit/ui/mypage/widgets/mypage.dart';
import 'package:teeklit/ui/mypage/widgets/notice_list.dart';
import 'package:teeklit/ui/mypage/widgets/public_data_source.dart';
import 'package:teeklit/ui/mypage/widgets/terms_policy.dart';
import 'package:teeklit/ui/teekle/widgets/teekle_main.dart';
import 'package:teeklit/ui/teekle/widgets/teekle_setting_page.dart';
import 'package:teeklit/ui/teekle/widgets/teekle_select_workout.dart';

import '../domain/model/task.dart';
import '../domain/model/teekle.dart';
import '../ui/mypage/widgets/profile_edit.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
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

    // GoRoute(
    //   path: '/profile-image-edit',
    //   builder: (context, state) => const ProfileEditScreen(),
    // ),

    GoRoute(
      path: '/profile-edit',
      builder: (context, state) => const ProfileEditScreen(),
    ),

    //회원탈퇴
    GoRoute(
      path: '/delete-account',
      builder: (context, state) => const DeleteAccountScreen(),
    ),

    GoRoute(
      path: '/alert-setting',
      builder: (context, state) => const AlertSettingScreen(),
    ),
    GoRoute(
      path: '/account-setting',
      builder: (context, state) => const AccountSettingsScreen(),
    ),
    GoRoute(
      path: '/notice-list',
      builder: (context, state) => const NoticeListScreen(),
    ),
    GoRoute(
      path: '/terms-policy',
      builder: (context, state) => const TermsPolicyScreen(),
    ),
    GoRoute(
      path: '/public-data-source',
      builder: (context, state) => const PublicDataSourceScreen(),
    ),

    ShellRoute(
      builder: (context, state, shellChild) {
        return NavigationView(child: shellChild);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/teekle',
          name: 'teekle',
          builder: (context, state) => const TeekleMainScreen(),
        ),
        GoRoute(
          path: '/community',
          name: 'communityMain',
          builder: (context, state) => const CommunityMainPage(),
        ),
        GoRoute(
          path: '/my',
          name: 'my',
          builder: (context, state) => const MyPageScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/community/write',
      name: 'communityWrite',
      builder: (context, state) => const CommunityPostWritePage(),
    ),
    GoRoute(
      path: '/community/view',
      name: 'communityView',
      builder: (context, state) => const CommunityPostViewPage(),
    ),
    GoRoute(
      path: '/teekle/addTodo',
      name: 'teekleAddTodo',
      builder: (context, state) => const TeekleSettingPage(
        type: TeeklePageType.addTodo,
      ),
    ),
    GoRoute(
      path: '/teekle/editTodo',
      name: 'teekleEditTodo',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final teekle = data['teekle'] as Teekle;
        final task = data['task'] as Task;

        return TeekleSettingPage(
          type: TeeklePageType.editTodo,
          teekleToEdit: teekle,
          originalTask: task,
        );
      },
    ),
    GoRoute(
      path: '/teekle/addWorkout',
      name: 'teekleAddWorkout',
      builder: (context, state) => const TeekleSettingPage(
        type: TeeklePageType.addWorkout,
      ),
    ),
    GoRoute(
      path: '/teekle/editWorkout',
      name: 'teekleEditWorkout',
      builder:(context, state) {
        final data = state.extra as Map<String, dynamic>;
        final teekle = data['teekle'] as Teekle;
        final task = data['task'] as Task;

        return TeekleSettingPage(
          type: TeeklePageType.editWorkout,
          teekleToEdit: teekle,
          originalTask: task,
        );
      },
    ),
    GoRoute(
      path: '/teekle/selectWorkout',
      name: 'teekleSelectWorkout',
      builder: (context, state) => const TeekleSelectWorkoutScreen(),
    ),
  ],
);
