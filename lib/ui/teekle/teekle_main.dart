import 'dart:math';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'widgets/teekle_list_item.dart';
import 'widgets/random_teekle_card.dart';

import 'widgets/progress_card.dart';


class Event {
  String title;
  Event(this.title);
}

class TeekleItemData {
  final String title;
  final String tag;
  final Color color;
  final String time;
  bool isDone;

  TeekleItemData({
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
  final List<TeekleItemData> _teekles = [
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

  // 랜덤 무브 후보들
  final List<TeekleItemData> _randomCandidates = [
    TeekleItemData(
      title: '밖에서 10분 산책하기',
      tag: '운동',
      color: Colors.greenAccent,
      time: '8:00 AM',
    ),
    TeekleItemData(
      title: '감사 일기 3줄 쓰기',
      tag: '마음',
      color: Colors.lightBlueAccent,
      time: '22:00',
    ),
    TeekleItemData(
      title: '물 한 컵 마시고 스트레칭 5분',
      tag: '건강',
      color: Colors.tealAccent,
      time: '9:00 AM',
    ),
  ];

  int get _doneCount => _teekles.where((t) => t.isDone).length;

  int get _totalCount => _teekles.length;

  double get _progress => _totalCount == 0 ? 0 : _doneCount / _totalCount;

  bool _isFabOpen = false;

  void _toggleFabMenu() {
    setState(() {
      _isFabOpen = !_isFabOpen;
    });
  }

  void _onAddTodo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('내 투두 추가 눌림 (추후 화면 이동 예정)'),
        backgroundColor: Colors.grey[800],
      ),
    );
    _toggleFabMenu();
  }

  void _onAddExercise() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('내 운동 추가 눌림 (추후 화면 이동 예정)'),
        backgroundColor: Colors.grey[800],
      ),
    );
    _toggleFabMenu();
  }

  void _shareTeekle(TeekleItemData teekle) {
    // TODO: 나중에 실제 공유 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('\'${teekle.title}\' 공유하기 눌림 (추후 구현 예정)'),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  Future<void> _onRandomPick() async {
    final existingTitles = _teekles.map((teekle) => teekle.title).toSet();
    final candidates = _randomCandidates
        .where((c) => !existingTitles.contains(c))
        .toList();

    if (candidates.isEmpty) {
      // 더 이상 추가할 랜덤 무브 없을 때
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('추가할 랜덤 무브가 더 이상 없어요.'),
          backgroundColor: Colors.grey[800],
        ),
      );
      return;
    }

    final random = Random();
    final selected = candidates[random.nextInt(candidates.length)];

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF252525),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('오늘의 랜덤 무브', style: TextStyle(color: Colors.white)),
        content: Text(
          '${selected.title}\n\n내 티클에 추가할까요?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('예'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        _teekles.add(selected);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('\'${selected.title}\' 이(가) 내 티클에 추가됐어요!'),
          backgroundColor: Colors.grey[800],
        ),
      );
    }
  }

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<Event>> events = {
    DateTime.utc(2025,11,20) : [ Event('title'), Event('title2') ],
    DateTime.utc(2025,11,21) : [ Event('title3') ],
  };

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 티클',
          style: TextStyle(
            fontFamily: 'Paperlogy',
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.bg,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                ProgressCard(
                  doneCount: _doneCount,
                  totalCount: _totalCount,
                  progress: _progress,
                ),
                const SizedBox(height: 16),
                RandomMoveCard(onPick: _onRandomPick),

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

                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  availableGestures: AvailableGestures.horizontalSwipe,

                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: false,
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Paperlogy',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  calendarStyle: CalendarStyle(
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),

                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green,
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border(top: BorderSide(width: 1, color: AppColors.green), bottom: BorderSide(width: 1, color: AppColors.green), right: BorderSide(width: 1, color: AppColors.green), left: BorderSide(width: 1, color: AppColors.green))
                    ),

                    markersAlignment: Alignment.center,
                    markersMaxCount: 1,
                    markerSizeScale: 1.0,
                    markersAnchor: 1.0,
                    markerDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.btnDarkBg.withValues(alpha: 0.7),
                    ),

                    defaultTextStyle: TextStyle(color: AppColors.txtGray),
                    outsideDaysVisible: false,
                  ),

                  eventLoader:  _getEventsForDay,

                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isEmpty) return const SizedBox.shrink();

                      if (isSameDay(date, selectedDay)) {
                        return const SizedBox.shrink();
                      }

                      return Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.btnDarkBg.withValues(alpha: 0.7),
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: const TextStyle(
                                color: AppColors.txtGray,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      this.selectedDay = selectedDay;
                      this.focusedDay = focusedDay;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay, day);
                  },
                ),

                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _teekles.length,
                  itemBuilder: (context, index) {
                    final teekle = _teekles[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Dismissible(
                        key: ValueKey(teekle.title),
                        direction: DismissDirection.horizontal,

                        background: Container(
                          //좌 -> 우
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          alignment: Alignment.centerLeft,
                          color: Color(0xFF121212),
                          child: const Row(
                            children: [Icon(Icons.reply, color: Colors.white)],
                          ),
                        ),

                        secondaryBackground: Container(
                          //우 -> 좌
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerLeft,
                          color: Color(0xFF121212),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Icon(Icons.check, color: Colors.white)],
                          ),
                        ),

                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            _shareTeekle(teekle);
                          } else if (direction == DismissDirection.endToStart) {
                            setState(() {
                              teekle.isDone = !teekle.isDone;
                            });
                          }
                        },

                        child: TeekleListItem(
                          title: teekle.title,
                          tag: teekle.tag,
                          color: teekle.color,
                          time: teekle.time,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (_isFabOpen) ...[
            // 반투명 배경
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleFabMenu,
                child: Container(color: Colors.black.withAlpha(100)),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 96,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _FabMenuItem(
                    label: '내 투두 추가',
                    icon: Icons.checklist_rtl,
                    onTap: _onAddTodo,
                  ),
                  const SizedBox(height: 16),
                  _FabMenuItem(
                    label: '내 운동 추가',
                    icon: Icons.directions_run,
                    onTap: _onAddExercise,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _toggleFabMenu,
        child: Icon(_isFabOpen ? Icons.close : Icons.add),
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

class _FabMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FabMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const bubbleColor = Color(0xFFCADF9C);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: bubbleColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
