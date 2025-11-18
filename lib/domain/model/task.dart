import 'package:uuid/uuid.dart';

/// taseId, teekleId 생성을 위한 UUID 생성기 선언
const uuid = Uuid();

///==================== enum 정의 ====================
/// 화면 표시 위해 enum에 custom value 지정, 한국어 표시 사용하기 위한 fromName 메소드 지정.
enum TaskType { todo, workout }

enum RepeatUnit {
  weekly('주간'),
  monthly('월간');

  final String kor;

  const RepeatUnit(this.kor);

  static RepeatUnit fromName(String name) {
    return RepeatUnit.values.firstWhere((e) => e.name == name);
  }
}

enum DayOfWeek {
  monday('월'),
  tuesday('화'),
  wednesday('수'),
  thursday('목'),
  friday('금'),
  saturday('토'),
  sunday('일');

  final String kor;

  const DayOfWeek(this.kor);

  static DayOfWeek fromName(String name) {
    return DayOfWeek.values.firstWhere((e) => e.name == name);
  }
}

///==================== Repeat 모델 정의 ====================
class Repeat {
  final bool hasRepeat;
  final RepeatUnit? unit;
  final int? interval;
  final List<DayOfWeek>? daysOfWeek; //선택된 요일

  Repeat({required this.hasRepeat, this.unit, this.interval, this.daysOfWeek});

  Map<String, dynamic> toMap() {
    if(!hasRepeat) {
      return {'hasRepeat' : false};
    }

    return {
      'hasRepeat' : true,
      'unit' : unit?.name,
      'interval' : interval,
      'daysOfWeek' : daysOfWeek?.map((e) => e.name).toList(),
    };
  }

  factory Repeat.fromMap(Map<String, dynamic> map) {
    bool hasRepeat = map['hasRepeat'] ?? false;

    if (!hasRepeat) {
      /// 반복x면 나머지는 Null처리
      return Repeat(hasRepeat: false);
    }

    return Repeat(
      hasRepeat: true,
      unit: map['unit'] != null
          ? RepeatUnit.fromName(map['unit']) : null,
      interval: map['interval'],
      daysOfWeek: map['daysOfWeek'] != null
          ? (map['daysOfWeek'] as List)
                .map((v) => DayOfWeek.fromName(v))
                .toList()
          : null,
    );
  }
}

///==================== Noti 모델 정의 ====================
class Noti {
  final bool hasNoti;
  final DateTime? notiTime;

  Noti({required this.hasNoti, this.notiTime});

  Map<String, dynamic> toMap() {
    if (!hasNoti) {
      return {'hasNoti': false};
    }

    return {
      'hasNoti' : true,
      'notiTime' : notiTime?.toIso8601String(),
    };
  }

  factory Noti.fromMap(Map<String, dynamic> map) {
    bool hasNoti = map['hasRepeat'] ?? false;

    if (!hasNoti) {
      return Noti(hasNoti: false);
    }
    return Noti(
      hasNoti: true,
      notiTime: map['notiTime'] != null
          ? DateTime.parse(map['notiTime'])
          : null,
    );
  }
}

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
