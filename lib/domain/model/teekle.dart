import 'enums.dart';
import 'package:teeklit/domain/model/task.dart';
import 'noti.dart';

///==================== Teekle 모델 정의 ====================
class Teekle {
  final int teekleId;
  final int taskId;
  final TaskType type;
  final DateTime execDate;
  final String title;
  final String tag;
  final bool isDone;
  final Noti noti;
  final String? url;

  Teekle({
    required this.teekleId,
    required this.taskId,
    required this.type,
    required this.execDate,
    required this.title,
    required this.tag,
    this.isDone = false,
    required this.noti,
    this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'teekleId' : teekleId,
      'taskId' : taskId,
      'type' : type.name,
      'execDate' : execDate.toIso8601String(),
      'title' : title,
      'tag' : tag,
      'isDone' : isDone,
      'noti' : noti.toMap(),
      'url' : url,
    };
  }

  factory Teekle.fromMap(Map<String, dynamic> map) {
    return Teekle(
      teekleId: map['teekleId'],
      taskId: map['taskId'],
      type: TaskType.values[map['type']],
      execDate: DateTime.parse(map['execDate']),
      title: map['title'],
      tag: map['tag'],
      isDone: map['isDone'],
      noti: Noti.fromMap(map['noti']),
      url: map['url'],
    );
  }
}

