import 'package:teeklit/domain/model/teekle/workout_video.dart';

class WorkoutResponse {
  final int currentCount;
  final int matchCount;
  final int page;
  final int perPage;
  final int totalCount;
  final List<WorkoutVideo> data;

  WorkoutResponse({
    required this.currentCount,
    required this.matchCount,
    required this.page,
    required this.perPage,
    required this.totalCount,
    required this.data,
  });

  factory WorkoutResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>;
    return WorkoutResponse(
      currentCount: json['currentCount'] as int,
      matchCount: json['matchCount'] as int,
      page: json['page'] as int,
      perPage: json['perPage'] as int,
      totalCount: json['totalCount'] as int,
      data: list.map((e) => WorkoutVideo.fromJson(e)).toList(),
    );
  }
}
