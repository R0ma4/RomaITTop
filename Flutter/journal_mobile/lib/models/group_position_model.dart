import 'leaderboard_user.dart';
class GroupPositionModel {
  final List<LeaderboardUser> groupLeaders;

  GroupPositionModel({required this.groupLeaders});

  factory GroupPositionModel.fromJson(List<dynamic> jsonList) {
    return GroupPositionModel(
      groupLeaders: jsonList.map((leaderJson) => LeaderboardUser.fromJson(leaderJson)).toList(),
    );
  }
}