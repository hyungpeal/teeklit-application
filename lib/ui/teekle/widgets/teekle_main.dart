import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teeklit/data/repositories/repository_task.dart';
import 'package:teeklit/data/repositories/repository_teekle.dart';
import 'package:teeklit/domain/model/enums.dart';
import 'package:teeklit/domain/model/teekle.dart';
import 'package:teeklit/domain/model/task.dart';
import 'package:teeklit/ui/teekle/providers/teekle_stats_provider.dart';
import '../../core/themes/colors.dart';
import 'teekle_list_item.dart';
import 'random_teekle_card.dart';

import 'progress_card.dart';
import 'package:teeklit/ui/teekle/view_model/view_model_teekle_setting.dart';


class TeekleMainScreen extends StatefulWidget {
  const TeekleMainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TeekleMainScreenState();
}

class _TeekleMainScreenState extends State<TeekleMainScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  final TeekleRepository _teekleRepository = TeekleRepository();
  String? _currentUserId;

  // 한 달치 데이터를 날짜별로 모아두는 맵
  final Map<DateTime, List<Teekle>> _teeklesByDay = {};
  bool _isLoading = false;
  String? _errorMessage;

  List<Teekle> _teeklesForDay = []; //선택된 날의 티클

  // 랜덤 티클 후보들
  List<Task> _randomCandidates = [];
  bool _isRandomLoading = false;
  String? _randomErrorMessage;

  // 랜덤티클 생성을 위한 뷰모델 선언
  late TeekleSettingViewModel _viewModel;

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _refreshSelectedDayFromMap() {
    final key = _normalizeDate(selectedDay);
    _teeklesForDay = _teeklesByDay[key] ?? [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TeekleStatsProvider>().updateTeeklesForDay(_teeklesForDay);
      }
    });
  }

  int _calculateStreakDays() {
    DateTime cursor = _normalizeDate(DateTime.now());
    int streak = 0;

    while (true) {
      final key = _normalizeDate(cursor);
      final list = _teeklesByDay[key] ?? [];

      // 1) 그날 티클이 아예 없으면 streak 종료
      if (list.isEmpty) break;

      // 2) 그날 티클이 모두 완료되어야 "성공한 하루"로 인정
      final allDone = list.isNotEmpty && list.every((t) => t.isDone == true);
      if (!allDone) break;

      // 3) 성공한 하루 → streak 증가, 하루 전으로 이동
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Future<void> _loadTeeklesForMonth(DateTime month) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_currentUserId == null) return;

    try {
      final teekles = await _teekleRepository.getTeeklesForMonth(month);

      // 날짜별로 그룹핑
      _teeklesByDay.clear();
      for (final t in teekles) {
        final dayKey = _normalizeDate(t.execDate);
        _teeklesByDay.putIfAbsent(dayKey, () => []);
        _teeklesByDay[dayKey]!.add(t);
      }

      // 현재 선택된 날짜의 리스트 갱신
      _refreshSelectedDayFromMap();

      final streak = _calculateStreakDays();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<TeekleStatsProvider>().updateStreakDays(streak);
        }
      });
    } catch (e) {
      _errorMessage = '티클 불러오기 실패: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRandomCandidates() async {
    setState(() {
      _isRandomLoading = true;
      _randomErrorMessage = null;
    });
    try {
      final candidates = await _teekleRepository.getRandomTaskCandidates();  // ✏️ 메서드명 변경

      print('=== 로드된 랜덤 Task 후보 ===');
      for (var i = 0; i < candidates.length; i++) {
        final c = candidates[i];
        print('[$i]');
        print('  title: ${c.title}');
        print('  type: ${c.type}');
        print('  taskId: ${c.taskId}');
        print('---');
      }

      setState(() {
        _randomCandidates = candidates;
      });
    } catch (e) {
      print('랜덤 Task 후보 로드 오류: $e');
      setState(() {
        _randomErrorMessage = '랜덤 후보 불러오기 실패: $e';
      });
    } finally {
      setState(() {
        _isRandomLoading = false;
      });
    }
  }

  // Future<void> _onRandomPick() async {
  //   if (_isRandomLoading) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: const Text('랜덤 무브를 불러오는 중이에요. 잠시만요!'),
  //         backgroundColor: Colors.grey[800],
  //       ),
  //     );
  //     return;
  //   }
  //
  //   if (_randomCandidates.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: const Text('등록된 랜덤 무브 후보가 없어요.'),
  //         backgroundColor: Colors.grey[800],
  //       ),
  //     );
  //     return;
  //   }
  //
  //   // 1. 오늘 날짜에 이미 있는 제목들은 제외 (중복 방지)
  //   final existingTitles = _teeklesForDay.map((t) => t.title).toSet();
  //   final candidates = _randomCandidates
  //       .where((c) => !existingTitles.contains(c.title))
  //       .toList();
  //
  //   if (candidates.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: const Text('추가할 랜덤 무브가 더 이상 없어요.'),
  //         backgroundColor: Colors.grey[800],
  //       ),
  //     );
  //     return;
  //   }
  //
  //   // 2. 랜덤으로 하나 고르기
  //   final random = Random();
  //   final template = candidates[random.nextInt(candidates.length)];
  //
  //   // 3. 다이얼로그로 사용자 확인
  //   final result = await showDialog<bool>(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       backgroundColor: const Color(0xFF252525),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       title: const Text('오늘의 랜덤 무브', style: TextStyle(color: Colors.white)),
  //       content: Text(
  //         '${template.title}\n\n내 티클에 추가할까요?',
  //         style: const TextStyle(color: Colors.white70),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(false),
  //           child: const Text('아니오'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(true),
  //           child: const Text('예'),
  //         ),
  //       ],
  //     ),
  //   );
  //
  //   if (result != true) return;
  //
  //   // 4. 실제 저장할 랜덤 Teekle 객체 만들기 (오늘 날짜 + 새 ID)
  //
  //
  //   try {
  //     await _teekleRepository.createTeekle(newTeekle);
  //     final key = _normalizeDate(selectedDay);
  //
  //     setState(() {
  //       _teeklesByDay.putIfAbsent(key, () => []);
  //       _teeklesByDay[key]!.add(newTeekle);
  //       _teeklesForDay = _teeklesByDay[key]!;
  //     });
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('\'${newTeekle.title}\' 이(가) 내 티클에 추가됐어요!'),
  //         backgroundColor: Colors.grey[800],
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('랜덤 티클 추가 실패: $e'),
  //         backgroundColor: Colors.red[700],
  //       ),
  //     );
  //   }
  // }
  Future<void> _onRandomPick() async {
    if (_isRandomLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('랜덤 티클을 불러오는 중이에요. 잠시만요!'),
            backgroundColor: Colors.grey[800],
            ),
          );
          return;
      }

          if (_randomCandidates.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('등록된 랜덤 티클 후보가 없어요.'),
            backgroundColor: Colors.grey[800],
          ),
        );
        return;
      }

    // 1. 오늘 날짜에 이미 있는 제목들은 제외 (중복 방지)
      final existingTitles = _teeklesForDay.map((t) => t.title).toSet();
      final candidates = _randomCandidates
          .where((c) => !existingTitles.contains(c.title))
          .toList();

      if (candidates.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('추가할 랜덤 티클이 더 이상 없어요.'),
            backgroundColor: Colors.grey[800],
          ),
        );
        return;
      }

    // 2. 랜덤으로 하나 고르기
      final random = Random();
      final template = candidates[random.nextInt(candidates.length)];

    // 3. 다이얼로그로 사용자 확인
      final result = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF252525),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('오늘의 랜덤 티클', style: TextStyle(color: Colors.white)),
          content: Text(
            '${template.title}\n\n내 티클에 추가할까요?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('아니오'),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: const Text('예'),
            ),
          ],
        ),
      );

      if (result != true) return;

      /// 4. 실제 저장할 랜덤 Teekle 객체 만들기 (오늘 날짜 + 새 ID)
      try {
        /// template 객체의 필드 검증
        if (template.title == null || template.title!.isEmpty) {
          throw Exception('템플릿의 제목이 비어있습니다.');
        }

        _viewModel.setTitle(template.title);
        _viewModel.setDate(selectedDay);

        /// 기본값 설정
        final taskType = template.type;
        final tag = null;

        bool success = await _viewModel.saveTask(
          taskType: taskType,
          tag: tag,
        );

        if (success && mounted) {
          /// 새로고침 전에 약간의 지연 추가
          await Future.delayed(const Duration(milliseconds: 500));
          await _loadTeeklesForMonth(selectedDay);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('\'${template.title}\' 이(가) 내 티클에 추가되었어요!'),
              backgroundColor: Colors.grey[800],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('랜덤 티클 추가 실패'),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      } catch (e) {
        print('로직 오류: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('랜덤 티클 추가 실패: ${e.toString()}'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    }

  List<Teekle> _eventLoader(DateTime day) {
    final key = _normalizeDate(day);
    final list = _teeklesByDay[key] ?? [];

    return list.where((t) => !t.isDone).toList();
  }

  final List<Color> teekleColors = [
    AppColors.green,
    AppColors.blue,
    AppColors.orange,
    AppColors.pink,
  ];

  int get _doneCount => teeklesForDay.where((t) => t.isDone).length;

  int get _totalCount => teeklesForDay.length;

  double get _progress => _totalCount == 0 ? 0 : _doneCount / _totalCount;

  bool _isFabOpen = false;

  bool _isCalendarMode = true;

  void _toggleFabMenu() {
    setState(() {
      _isFabOpen = !_isFabOpen;
    });
  }

  void _onAddTodo() async {
    _toggleFabMenu();

    final result = await context.pushNamed<bool>('teekleAddTodo') ?? false;

    if (result == true) {
      _loadTeeklesForMonth(selectedDay);
    }
  }

  void _onAddExercise() async {
    _toggleFabMenu();

    final result = await context.pushNamed<bool>('teekleAddWorkout') ?? false;

    if (result == true) {
      _loadTeeklesForMonth(selectedDay);
    }
  }

  void _shareTeekle(Teekle teekle) {
    // TODO: 나중에 실제 공유 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('\'${teekle.title}\' 공유하기 눌림 (추후 구현 예정)'),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  final weekdayNames = ['월', '화', '수', '목', '금', '토', '일'];

  List<Teekle> get teeklesForDay => _teeklesForDay;

  List<Teekle> get teeklesForDayNotDone =>
      _teeklesForDay.where((t) => !t.isDone).toList();

  @override
  void initState() {
    super.initState();
    _loadTeeklesForMonth(selectedDay);
    _loadRandomCandidates();
    _viewModel = TeekleSettingViewModel();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUserId = user.uid;
      _loadTeeklesForMonth(DateTime.now());
    } else {
      _currentUserId = 'guest';
      print("로그인된 사용자가 없습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ProgressCard(
                    day:
                        '${selectedDay.month}월 ${selectedDay.day}일 ${weekdayNames[selectedDay.weekday - 1]}요일',
                    doneCount: _doneCount,
                    totalCount: _totalCount,
                    progress: _progress,
                  ),
                  const SizedBox(height: 16),

                  RandomMoveCard(onPick: _onRandomPick),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCalendarMode = false;
                          });
                        },
                        child: Text(
                          '리스트',
                          style: TextStyle(
                            color: _isCalendarMode
                                ? Colors.white54
                                : Colors.white,
                            fontFamily: 'Paperlogy',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCalendarMode = true;
                          });
                        },
                        child: Text(
                          '캘린더',
                          style: TextStyle(
                            color: _isCalendarMode
                                ? Colors.white
                                : Colors.white54,
                            fontFamily: 'Paperlogy',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_isCalendarMode)
                    TableCalendar(
                      locale: 'ko_KR',
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2035, 3, 14),
                      focusedDay: focusedDay,
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
                          border: Border(
                            top: BorderSide(width: 1, color: AppColors.green),
                            bottom: BorderSide(
                              width: 1,
                              color: AppColors.green,
                            ),
                            right: BorderSide(width: 1, color: AppColors.green),
                            left: BorderSide(width: 1, color: AppColors.green),
                          ),
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

                      eventLoader: _eventLoader,

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
                                color: AppColors.btnDarkBg.withValues(
                                  alpha: 0.7,
                                ),
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
                        final key = _normalizeDate(selectedDay);
                        _teeklesForDay = _teeklesByDay[key] ?? [];
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDay, day);
                      },

                      onPageChanged: (newFocusedDay) {
                        setState(() {
                          focusedDay = newFocusedDay;
                        });
                        _loadTeeklesForMonth(newFocusedDay);
                      },
                    ),

                  teeklesForDayNotDone.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.green.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '앗! 이날은 예정된 티클이 없어요 🧐 ',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: teeklesForDayNotDone.length,
                          itemBuilder: (context, index) {
                            final teekle = teeklesForDayNotDone[index];

                            return GestureDetector(
                              onTap: () async {
                                final task = await _taskRepository.getTask(
                                  teekle.taskId,
                                );

                                final routeName = teekle.type == TaskType.todo
                                    ? 'teekleEditTodo'
                                    : 'teekleEditWorkout';

                                final result = await context.pushNamed<bool>(
                                  routeName,
                                  extra: {
                                    'teekle': teekle,
                                    'task': task,
                                  },
                                ) ?? false;


                                if (result == true) {
                                  print('수정후');
                                  _loadTeeklesForMonth(selectedDay);
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Dismissible(
                                  key: ValueKey(teekle.title),
                                  direction: DismissDirection.endToStart,

                                  background: Container(
                                    //좌 -> 우
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    color: AppColors.bg,
                                    child: const Row(
                                      children: [
                                        Icon(Icons.reply, color: Colors.white),
                                      ],
                                    ),
                                  ),

                                  secondaryBackground: Container(
                                    //우 -> 좌
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    color: AppColors.bg,
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.check, color: Colors.white),
                                      ],
                                    ),
                                  ),

                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      // _shareTeekle(teekle);
                                      return false;
                                    } else if (direction ==
                                        DismissDirection.endToStart) {
                                      setState(() {
                                        teekle.isDone = true;
                                        _refreshSelectedDayFromMap();
                                      });
                                      _teekleRepository.updateTeekle(teekle);
                                    }
                                  },

                                  child: TeekleListItem(
                                    title: teekle.title,
                                    tag: teekle.tag?.tagName,
                                    color:
                                        teekleColors[index %
                                            teekleColors.length],
                                    time: teekle.noti.hasNoti == false
                                        ? null
                                        : '${teekle.noti.notiTime?.hour.toString().padLeft(2, '0')}:${teekle.noti.notiTime?.minute.toString().padLeft(2, '0')}',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
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
                    icon: SvgPicture.asset(
                      'assets/icons/checklist.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    onTap: _onAddTodo,
                  ),
                  const SizedBox(height: 16),
                  _FabMenuItem(
                    label: '내 운동 추가',
                    icon: SvgPicture.asset(
                      'assets/icons/physical_therapy.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    onTap: _onAddExercise,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.btnDarkBg,
        foregroundColor: Colors.white,
        onPressed: _toggleFabMenu,
        shape: CircleBorder(),
        child: Icon(_isFabOpen ? Icons.close : Icons.add),
      ),
    );
  }
}

class _FabMenuItem extends StatelessWidget {
  final String label;
  final Widget icon;
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
            child: Center(
              child: icon,
            ),
          ),
        ],
      ),
    );
  }
}
