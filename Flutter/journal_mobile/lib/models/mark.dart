class Mark {
  final String specName;
  final String lessonTheme;
  final String dateVisit;
  final int? homeWorkMark;
  final int? controlWorkMark;
  final int? labWorkMark;
  final int? classWorkMark;

  Mark({
    required this.specName,
    required this.lessonTheme,
    required this.dateVisit,
    this.homeWorkMark,
    this.controlWorkMark,
    this.labWorkMark,
    this.classWorkMark,
  });

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      specName: json['spec_name'],
      lessonTheme: json['lesson_theme'],
      dateVisit: json['date_visit'],
      homeWorkMark: json['home_work_mark'],
      controlWorkMark: json['control_work_mark'] as int?,
      labWorkMark: json['lab_work_mark'] as int?,
      classWorkMark: json['class_work_mark'] as int?,
    );
  }
}