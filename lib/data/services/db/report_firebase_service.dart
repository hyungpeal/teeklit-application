import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teeklit/domain/model/community/report.dart';

class ReportFirebaseService {
  final  reportRef = FirebaseFirestore.instance.collection('reports');

  /// 신고하기 기능
  Future<void> submitReport(Report report) async {
    await reportRef.add(report.toJson());
  }

  /// 전체 신고 목록 가져오기
  Future<List<Report>> getReports() async {
    final snapshot = await reportRef.get();

    List<Report> reportsList = [];

    for(var i in snapshot.docs){
      reportsList.add(Report.fromJson(i));
    }
    
    return reportsList;
  }
}
