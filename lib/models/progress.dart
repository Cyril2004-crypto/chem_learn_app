class Progress {
  final String userId;
  final Map<String, bool> lessonsCompleted; // lessonId -> completed

  Progress({required this.userId, Map<String, bool>? lessons})
      : lessonsCompleted = lessons ?? {};

  void markCompleted(String lessonId) => lessonsCompleted[lessonId] = true;

  double completionPercent(int totalLessons) {
    if (totalLessons == 0) return 0.0;
    final done = lessonsCompleted.values.where((v) => v).length;
    return (done / totalLessons) * 100.0;
  }

  Map<String, dynamic> toMap() => {'userId': userId, 'lessonsCompleted': lessonsCompleted};
}