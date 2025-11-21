// DateTime 확장 함수 (picker에서 설정값으로 사용하기 위한 가공)
extension DateTimeExtension on DateTime {
  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }
}