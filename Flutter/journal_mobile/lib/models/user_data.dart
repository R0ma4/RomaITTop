// данные пользователя
class UserData {
  final int studentId;
  final String fullName;
  final String groupName;

  UserData({
    required this.studentId,
    required this.fullName,
    required this.groupName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      studentId: json['student_id'],
      fullName: json['full_name'],
      groupName: json['group_name'],
    );
  }
}