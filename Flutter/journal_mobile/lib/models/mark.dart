// для оценок
class Mark {
  final String specName;
  final String lessonTheme;
  final String dateVisit;
  final int? homeWorkMark;

  Mark({
    required this.specName,
    required this.lessonTheme,
    required this.dateVisit,
    this.homeWorkMark,
  });

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      specName: json['spec_name'],
      lessonTheme: json['lesson_theme'],
      dateVisit: json['date_visit'],
      homeWorkMark: json['home_work_mark'],
    );
  }
}