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

class GroupPositionModel {
  final List<LeaderboardUser> groupLeaders;

  GroupPositionModel({required this.groupLeaders});

  factory GroupPositionModel.fromJson(List<dynamic> jsonList) {
    return GroupPositionModel(
      groupLeaders: jsonList.map((leaderJson) => LeaderboardUser.fromJson(leaderJson)).toList(),
    );
  }
}

class StreamPositionModel {
  final List<LeaderboardUser> streamLeaders;

  StreamPositionModel({required this.streamLeaders});

  factory StreamPositionModel.fromJson(List<dynamic> jsonList) {
    return StreamPositionModel(
      streamLeaders: jsonList.map((leaderJson) => LeaderboardUser.fromJson(leaderJson)).toList(),
    );
  }
}