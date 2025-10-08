import 'package:flutter/material.dart';
import '../models/mark.dart';
import '../models/user_data.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  late Future<List<Mark>> _marksFuture;
  late Future<UserData> _userFuture;

  @override
  void initState() {
    super.initState();
    _marksFuture = _apiService.getMarks(widget.token);
    _userFuture = _apiService.getUser(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<UserData>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.fullName);
            }
            return const Text('Профиль');
          },
        ),
      ),
      body: FutureBuilder<List<Mark>>(
        future: _marksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Оценок не найдено'));
          }
          final marks = snapshot.data!;
          return ListView.builder(
            itemCount: marks.length,
            itemBuilder: (context, index) {
              final mark = marks[index];
              return ListTile(
                title: Text(mark.specName),
                subtitle: Text(mark.lessonTheme),
                trailing: Text(
                  mark.homeWorkMark?.toString() ?? 'Б/О', // Б/О - без оценки
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}