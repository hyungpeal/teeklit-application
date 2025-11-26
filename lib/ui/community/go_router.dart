import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teeklit/ui/community/community_main_page.dart';
import 'package:teeklit/ui/community/community_post_view_page.dart';
import 'package:teeklit/ui/community/community_post_write_page.dart';
import 'package:teeklit/ui/community/view_model/community_view_model.dart';
import 'package:teeklit/ui/community/view_model/report_view_model.dart';

class SampleCommunityHOme extends StatefulWidget {
  final Widget child;
  const SampleCommunityHOme({super.key, required this.child});

  @override
  State<SampleCommunityHOme> createState() => _SampleCommunityHOmeState();
}

class _SampleCommunityHOmeState extends State<SampleCommunityHOme> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommunityViewModel()),
        ChangeNotifierProvider(create: (_) => ReportViewModel()),
      ],
      child:widget.child ,
    );
  }
}


final GoRouter router = GoRouter(
  initialLocation: '/community',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return SampleCommunityHOme(child:child);
      },
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
      ]
    ),
  ],
);