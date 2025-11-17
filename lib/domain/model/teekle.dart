import 'package:teeklit/domain/model/task.dart';

/*==================== Teekle 모델 정의 ====================*/
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
}