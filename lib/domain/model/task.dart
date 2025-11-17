/*==================== enum 정의 ====================*/
enum TaskType { todo, workout }

enum RepeatPeriod { weekly, monthly }

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

/*==================== Repeat 모델 정의 ====================*/
class Repeat {
  final bool hasRepeat;
  final RepeatPeriod? unit; // 월간 / 주간
  final int? interval; // 1주마다, 2주마다, ... / 1달마다, 2달마다, ...
  final List<DayOfWeek>? daysOfWeek; //선택된 요일

  Repeat({
    required this.hasRepeat,
    this.unit,
    this.interval,
    this.daysOfWeek
  });
}

/*==================== Noti 모델 정의 ====================*/
class Noti {
  final bool hasNoti;
  final DateTime? notiTime;

  Noti({
    required this.hasNoti,
    this.notiTime
  });
}

/*==================== Task 모델 정의 ====================*/
class Task {
  final int taskId;
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
}


