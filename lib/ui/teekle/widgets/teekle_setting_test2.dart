import 'package:flutter/material.dart';
import 'package:teeklit/domain/model/enums.dart';
import 'package:teeklit/ui/teekle/widgets/teekle_setting_page.dart';
import 'package:teeklit/data/repositories/repository_teekle.dart';
import 'package:teeklit/data/repositories/repository_task.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({super.key});

  @override
  Widget build(BuildContext context) {
    final teekleRepository = TeekleRepository();
    final taskRepository = TaskRepository();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                    MaterialPageRoute(
                      builder: (context) => const TeekleSettingPage(
                        type: TeeklePageType.addTodo,
                      ),
                    ),
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
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () async {
                  /// e.g) 12/3의 teekle 조회 (실제로는 선택된 teekle을 받아옴)
                  DateTime selectedDate = DateTime(2025, 12, 3);

                  try {
                    final teekles =
                    await teekleRepository.getTeeklesByDate(selectedDate);

                    if (teekles.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('해당 날짜에 teekle이 없습니다')),
                      );
                      return;
                    }

                    /// 첫 번째 teekle 선택 (실제로는 사용자가 선택한 teekle)
                    final teekleToEdit = teekles.first;

                    /// 해당 teekle의 원본 task 조회
                    final originalTask =
                    await taskRepository.getTask(teekleToEdit.taskId);

                    if (originalTask == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('원본 Task를 찾을 수 없습니다')),
                      );
                      return;
                    }

                    /// 수정 페이지 이동 (teekle, task 데이터 전달)
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeekleSettingPage(
                            type: TeeklePageType.editTodo,
                            teekleToEdit: teekleToEdit,
                            originalTask: originalTask,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('데이터 조회 실패: $e')),
                    );
                  }
                },
                child: const Text(
                  '투두 수정하기 (12/3)',
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
                    MaterialPageRoute(
                      builder: (context) => const TeekleSettingPage(
                        type: TeeklePageType.addWorkout,
                      ),
                    ),
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
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () async {
                  /// 12/3의 workout teekle 조회
                  DateTime selectedDate = DateTime(2025, 12, 3);

                  try {
                    final teekles =
                    await teekleRepository.getTeeklesByDate(selectedDate);

                    if (teekles.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('해당 날짜에 teekle이 없습니다')),
                      );
                      return;
                    }

                    final teekleToEdit = teekles.first;

                    /// 조회된 Teekle 정보 확인
                    // print('단계 1: 조회된 Teekle =====');
                    // print('teekleId: ${teekleToEdit.teekleId}');
                    // print('taskId: ${teekleToEdit.taskId}');
                    // print('title: ${teekleToEdit.title}');
                    // print('noti.hasNoti: ${teekleToEdit.noti.hasNoti}');
                    // print('noti.notiTime: ${teekleToEdit.noti.notiTime}');
                    // print('================================');

                    final originalTask =
                    await taskRepository.getTask(teekleToEdit.taskId);

                    if (originalTask == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('원본 Task를 찾을 수 없습니다')),
                      );
                      return;
                    }

                    // 조회된 Task 정보 확인
                    // print('단계 2: 조회된 Task =====');
                    // print('taskId: ${originalTask.taskId}');
                    // print('title: ${originalTask.title}');
                    // print('noti.hasNoti: ${originalTask.noti.hasNoti}');
                    // print('noti.notiTime: ${originalTask.noti.notiTime}');
                    // print('================================');


                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeekleSettingPage(
                            type: TeeklePageType.editWorkout,
                            teekleToEdit: teekleToEdit,
                            originalTask: originalTask,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('데이터 조회 실패: $e')),
                    );
                  }
                },
                child: const Text(
                  '운동 수정하기 (12/3)',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}