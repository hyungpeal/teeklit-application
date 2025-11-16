import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/ui/community/community_main_page.dart';
import 'package:teeklit/ui/community/community_post_view_page.dart';
import 'package:teeklit/ui/community/community_post_write_page.dart';



final GoRouter router = GoRouter(
  initialLocation: '/community',
  routes: [
    GoRoute(
      path: '/community',
      name: 'communityMain',
      builder: (context, state) => CommunityMainPage(),
    ),
    GoRoute(
      path: '/community/write',
      name: 'communityWrite',
      builder: (context, state) => CommunityPostWritePage(),
    ),
    GoRoute(
      path: '/community/view',
      name: 'communityView',
      builder: (context, state) => CommunityPostViewPage(),
    ),
  ],
);