import 'enums.dart';

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