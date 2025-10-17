import 'leaderboard_user.dart';
class StreamPositionModel {
  final List<LeaderboardUser> streamLeaders;

  StreamPositionModel({required this.streamLeaders});

  factory StreamPositionModel.fromJson(List<dynamic> jsonList) {
    return StreamPositionModel(
      streamLeaders: jsonList.map((leaderJson) => LeaderboardUser.fromJson(leaderJson)).toList(),
    );
  }
}