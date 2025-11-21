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

enum TeeklePageType {
  addTodo,
  editTodo,
  addWorkout,
  editWorkout
}