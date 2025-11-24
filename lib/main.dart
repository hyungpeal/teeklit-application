// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teeklit/ui/community/go_router.dart';
import 'login/app_router.dart';
import 'ui/teekle/widgets/teekle_setting_test.dart';
import 'ui/teekle/widgets/teekle_setting_test2.dart';
import 'package:teeklit/login/app_router.dart';

//파이어베이스
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();      // ← 중요
  await Firebase.initializeApp(                   // ← 중요
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.collection('test').get().then((snapshot) {
    print('🔥 Firestore 연결 성공! 문서 개수: ${snapshot.docs.length}');
  }).catchError((e) {
    print('🔥 Firestore 연결 실패: $e');
  });

  runApp(const Teeklit());
}

class Teeklit extends StatelessWidget {
  const Teeklit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Paperlogy'),
    );
  }
}