import 'enums.dart';
import 'repeat.dart';
import 'noti.dart';

///==================== Task 모델 정의 ====================
class Task {
  final String taskId;
  final TaskType type;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Repeat repeat;
  final Noti noti;
  final String? url;

  Task({
    required this.taskId,
    required this.type,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.repeat,
    required this.noti,
    this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskId' : taskId,
      'type' : type.name,
      'title' : title,
      'startDate' : startDate.toIso8601String(),
      'endDate' : endDate.toIso8601String(),
      'repeat' : repeat.toMap(),
      'noti' : noti.toMap(),
      'url' : url,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskId: map['taskId'],
      type : TaskType.values.firstWhere((e) => e.name == map['type']),
      title : map['title'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      repeat: Repeat.fromMap(map['repeat']),
      noti: Noti.fromMap(map['noti']),
      url : map['url'],
    );
  }
}