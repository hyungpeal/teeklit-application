import 'package:flutter/material.dart';
import 'package:teeklit/data/repositories/report_firebase_repository.dart';
import 'package:teeklit/domain/model/community/report.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportFirebaseRepository _repo = ReportFirebaseRepository();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> submitReport(
    String targetId,
    String targetType,
    String reporterId,
    // String reason,
  ) async {
    isLoading = true;
    notifyListeners();

    final report = Report(
      targetId: targetId,
      targetType: targetType,
      reporterId: reporterId,
      // reason: reason,
      createdAt: DateTime.now(),
    );

    await _repo.submitReport(report);

    isLoading = false;
    notifyListeners();
    return true;
  }
}
