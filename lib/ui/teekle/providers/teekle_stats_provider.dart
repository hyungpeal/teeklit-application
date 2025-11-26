import 'package:flutter/material.dart';

import '../../../domain/model/teekle.dart';

class TeekleStatsProvider extends ChangeNotifier {
  List<Teekle> _currentDayTeekles = [];
  int _streakDays = 0;

  /// 오늘(선택된 날짜)의 티클 리스트를 통째로 업데이트
  void updateTeeklesForDay(List<Teekle> teekles) {
    _currentDayTeekles = List.unmodifiable(teekles);
    notifyListeners();
  }

  void updateStreakDays(int value) {
    _streakDays = value;
    notifyListeners();
  }

  List<Teekle> get teeklesForDay => _currentDayTeekles;

  int get doneCount => _currentDayTeekles.where((t) => t.isDone).length;

  int get totalCount => _currentDayTeekles.length;

  int get remainingCount => totalCount - doneCount;

  double get progress => totalCount == 0 ? 0 : doneCount / totalCount;

  int get streakDays => _streakDays;
}
