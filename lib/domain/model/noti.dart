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
    bool hasNoti = map['hasNoti'] ?? false;

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