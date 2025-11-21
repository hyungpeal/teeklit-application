import 'package:teeklit/domain/model/teekle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeekleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'teekles';

  /// Teekle 리스트 일괄 저장 메소드 (task랑 상관없이 한 폴더에 일괄 저장)
  Future<void> createTeekles(List<Teekle> teekles) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (Teekle teekle in teekles) {
        DocumentReference ref =
        _firestore.collection(_collectionName).doc(teekle.teekleId.toString());
        batch.set(ref, teekle.toMap());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Teekle 생성 실패: $e');
    }
  }

  /// Teekle 단일 저장
  Future<void> createTeekle(Teekle teekle) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(teekle.teekleId.toString())
          .set(teekle.toMap());
    } catch (e) {
      throw Exception('Teekle 생성 실패: $e');
    }
  }

  /// TaskID로 Teekle 리스트 조회
  Future<List<Teekle>> getTeeklesByTaskId(int taskId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('taskId', isEqualTo: taskId)
          .get();

      return querySnapshot.docs
          .map((doc) => Teekle.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Teekle 목록 조회 실패: $e');
    }
  }

  /// 특정 날짜의 Teekle 리스트 조회
  Future<List<Teekle>> getTeeklesByDate(DateTime date) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      // print('getTeeklesByDate 호출');
      // print('startOfDay: ${startOfDay.toIso8601String()}');
      // print('endOfDay: ${endOfDay.toIso8601String()}');

      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('execDate', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('execDate', isLessThan: endOfDay.toIso8601String())
          .get();

      // print('조회된 teekle 개수: ${querySnapshot.docs.length}');
      // for (var doc in querySnapshot.docs) {
      //   print('teekle: ${doc.id}, execDate: ${doc['execDate']}');
      // }

      return querySnapshot.docs
          .map((doc) => Teekle.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('날짜별 Teekle 조회 실패: $e');
    }
  }

  /// Teekle 업데이트
  Future<void> updateTeekle(Teekle teekle) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(teekle.teekleId.toString())
          .update(teekle.toMap());
    } catch (e) {
      throw Exception('Teekle 업데이트 실패: $e');
    }
  }

  /// 특정 날짜 이후의 teekle들 부분 삭제 (수정 시)
  ///
  /// 선택한 날짜를 포함하여 그 이후의 isDone=false인 teekles 삭제
  /// fromDate 날짜 이후의 teekle 삭제 (fromDate 날짜 포함)
  /// 12/3(수)의 teekle 수정 시 12/3, 12/5의 teekle들을 삭제 (이전날짜는 그대로 유지)
  Future<void> deleteTeeklesFromDateByTaskId({
    required String taskId,
    required DateTime fromDate,
  }) async {
    try {
      DateTime startOfDay = DateTime(fromDate.year, fromDate.month, fromDate.day);
      String startDateString = startOfDay.toIso8601String();

      // print('deleteTeeklesFromDateByTaskId 호출');
      // print('taskId: $taskId');
      // print('fromDate: $startDateString');

      /// 주의 - Firestore 쿼리는 순서대로 작성해뒀음!!
      /// taskId로 필터링 -> execDate로 필터링 -> isDone으로 필터링
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('taskId', isEqualTo: taskId)
          .where('execDate', isGreaterThanOrEqualTo: startDateString)
          .where('isDone', isEqualTo: false)
          .get();

      // print('삭제할 teekle 개수: ${querySnapshot.docs.length}');

      WriteBatch batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        // print('삭제할 teekle: ${doc.id}, execDate: ${doc['execDate']}');
        batch.delete(doc.reference);
      }

      await batch.commit();
      // print('deleteTeeklesFromDateByTaskId 완료');
    } catch (e) {
      throw Exception('날짜별 Teekle 삭제 실패: $e');
    }
  }

  /// 단일 Teekle 삭제 (수정 페이지에서)
  /// 사용자가 수정 페이지에서 삭제 버튼을 눌렀을 때 해당 날짜의 teekle만 삭제
  Future<void> deleteTeeklesByDate(DateTime date) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('execDate', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('execDate', isLessThan: endOfDay.toIso8601String())
          .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('날짜별 Teekle 삭제 실패: $e');
    }
  }
}
