// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teeklit/ui/teekle/teekle_main.dart';

void main() {
  runApp(const TeeklitApp());
}

class TeeklitApp extends StatelessWidget {
  const TeeklitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ko', 'KR'),

      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      title: 'Teeklit',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const TeekleMainScreen(),
    );
  }
}