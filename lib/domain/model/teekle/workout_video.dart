class WorkoutVideo {
  final int id;
  final String title;
  final String category;
  final String midCategory;
  final String topCategory;
  final String videoUrl;

  WorkoutVideo({
    required this.id,
    required this.title,
    required this.category,
    required this.midCategory,
    required this.topCategory,
    required this.videoUrl,
  });

  factory WorkoutVideo.fromJson(Map<String, dynamic> json) {
    return WorkoutVideo(
      id: json['번호'] as int,
      title: json['제목'] as String,
      category: json['소분류'] as String,
      midCategory: json['중분류'] as String,
      topCategory: json['대분류'] as String,
      videoUrl: json['동영상주소'] as String,
    );
  }
}
