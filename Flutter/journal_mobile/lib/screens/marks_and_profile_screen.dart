import 'package:flutter/material.dart';
import '../models/mark.dart';
import '../models/user_data.dart';
import '../services/api_service.dart';

class MarksAndProfileScreen extends StatefulWidget {
  final String token;
  const MarksAndProfileScreen({super.key, required this.token});

  @override
  State<MarksAndProfileScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MarksAndProfileScreen> {
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
              final markValue = mark.homeWorkMark?.toString() ?? 'Б/О';
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(
                          markValue,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: markValue == 'Б/О' ? Colors.grey : Colors.blue,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mark.specName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mark.lessonTheme,
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          mark.dateVisit,
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}