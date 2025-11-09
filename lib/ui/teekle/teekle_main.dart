import 'package:flutter/material.dart';
import 'widgets/teekle_list_item.dart';
import 'widgets/random_teekle_card.dart';

import 'widgets/progress_card.dart';

class TeekleItemData {
  final String title;
  final String tag;
  final Color color;
  final String time;
  final bool isDone;

  const TeekleItemData({
    required this.title,
    required this.tag,
    required this.color,
    required this.time,
    this.isDone = false,
  });
}

class TeekleMainScreen extends StatefulWidget {
  const TeekleMainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TeekleMainScreenState();
}

class _TeekleMainScreenState extends State<TeekleMainScreen> {
  final List<TeekleItemData> _teekle = [
    TeekleItemData(
      title: '분리수거하기',
      tag: '정리',
      color: Colors.greenAccent,
      time: '7:30 AM',
      isDone: true,
    ),
    TeekleItemData(
      title: '아침에 10분 명상하기',
      tag: '마음',
      color: Colors.lightBlueAccent,
      time: '7:30 AM',
    ),
    TeekleItemData(
      title: '운동처방 - 뻣뻣한 몸이 10분만에 말랑말랑!',
      tag: '운동',
      color: Colors.orangeAccent,
      time: '7:30 AM',
    ),
  ];

  int get _doneCount => _teekle.where((t) => t.isDone).length;

  int get _totalCount => _teekle.length;

  double get _progress => _totalCount == 0 ? 0 : _doneCount / _totalCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //상단 헤더
              const SizedBox(height: 12),
              const Text(
                '내 티클',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              ProgressCard(
                doneCount: _doneCount,
                totalCount: _totalCount,
                progress: _progress,
              ),
              const SizedBox(height: 16),
              RandomMoveCard(
                onPick: () {
                  final snackBar = SnackBar(
                    content: Text("오늘의 랜덤 무브는 아침에 10분 명상하기!"),
                    backgroundColor: Colors.grey,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),

              const SizedBox(height: 24),

              const Text(
                '리스트',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _teekle.map(
                      (teekle) => MoveListItem(
                        title: teekle.title,
                        tag: teekle.tag,
                        color: teekle.color,
                        time: teekle.time,
                      ),
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[800],
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: '내 티클'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        ],
      ),
    );
  }
}
