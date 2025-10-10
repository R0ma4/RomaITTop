import 'leaderboard_user.dart';
class LeaderPositionModel {
  final List<LeaderboardUser> leaders;

  LeaderPositionModel({required this.leaders});

  factory LeaderPositionModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> leadersData = json['leaders'] ?? [];
    return LeaderPositionModel(
      leaders: leadersData.map((leaderJson) => LeaderboardUser.fromJson(leaderJson)).toList(),
    );
  }
}