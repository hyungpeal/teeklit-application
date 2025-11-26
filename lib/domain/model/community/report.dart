import 'package:cloud_firestore/cloud_firestore.dart';

enum TargetType {
  post(value: 'post'),
  comment(value: 'comment');

  final String value;

  const TargetType({required this.value});
}
enum ReportStatus {
  pending(value: '보류중'),
  reviewing(value: '처리중'),
  resolved(value: '처리됨');

  final String value;

  const ReportStatus({required this.value});
}

class Report {
  final String? reportId;
  final String targetId;
  final String targetType;
  final String reporterId;
  // final String reason;
  final DateTime createdAt;
  final String status;

  Report({
    this.reportId,
    required this.targetId,
    required this.targetType,
    required this.reporterId,
    // required this.reason,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'targetId': targetId,
      'targetType': targetType,
      'reporterId': reporterId,
      // 'reason': reason,
      'createdAt': createdAt,
      'status': status,
    };
  }

  factory Report.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final Timestamp ts = data['createAt'];

    return Report(
      reportId: doc.id,
      targetId: data['targetId'],
      targetType: data['targetType'],
      reporterId: data['reporterId'],
      // reason: data['reason'],
      createdAt: DateTime.parse(ts.toDate().toString()),
      status: data['status'] ?? 'pending',
    );
  }
}
