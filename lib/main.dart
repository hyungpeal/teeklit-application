import 'package:flutter/material.dart';
import 'package:teeklit/ui/teekle/widgets/teekle_setting_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const Teeklit());
}

class Teeklit extends StatelessWidget {
  const Teeklit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Paperlogy'),
      home: const HomePage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ko', ''), // Korean, no country code
      ],
    );
  }
}

// 2. 새로운 홈페이지 위젯을 만듭니다.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. 이제 이 context는 MaterialApp의 자손이므로 Navigator를 찾을 수 있습니다.
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeekleSettingPage(type: TeeklePageType.addTodo,)),
                );
              },
              child: const Text(
                '투두 추가하기',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeekleSettingPage(type: TeeklePageType.editTodo,)),
                );
              },
              child: const Text(
                '투두 수정하기',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeekleSettingPage(type: TeeklePageType.addWorkout,)),
                );
              },
              child: const Text(
                '운동 추가하기',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeekleSettingPage(type: TeeklePageType.editWorkout,)),
                );
              },
              child: const Text(
                '운동 수정하기',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
