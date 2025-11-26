import 'package:teeklit/data/services/db/report_firebase_service.dart';
import 'package:teeklit/domain/model/community/report.dart';

class ReportFirebaseRepository {
  final ReportFirebaseService _reportService = ReportFirebaseService();

  Future<void> submitReport(Report report) async{
    _reportService.submitReport(report);
  }

  Future<List<Report>> getReports() async{
    return _reportService.getReports();
  }
}