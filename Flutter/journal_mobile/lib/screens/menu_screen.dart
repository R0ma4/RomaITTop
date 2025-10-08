import 'package:flutter/material.dart';
import 'marks_and_profile_screen.dart';
import 'schedule_screen.dart';
import '../models/mark.dart';
import '../services/api_service.dart';

class MainMenuScreen extends StatefulWidget {
  final String token;
  const MainMenuScreen({super.key, required this.token});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Mark>> _marksFuture;

  @override
  void initState() {
    super.initState();
    _marksFuture = _apiService.getMarks(widget.token);
  }

  Map<String, double> _calculateAverages(List<Mark> marks) {
    double totalHomeWorkMarks = 0;
    int homeWorkCount = 0;
    double totalControlWorkMarks = 0;
    int controlWorkCount = 0;
    double totalLabWorkMarks = 0;
    int labWorkCount = 0;
    double totalAllMarks = 0;
    int allMarksCount = 0;

    for (var mark in marks) {
      if (mark.homeWorkMark != null) {
        totalHomeWorkMarks += mark.homeWorkMark!;
        homeWorkCount++;
        totalAllMarks += mark.homeWorkMark!;
        allMarksCount++;
      }
      if (mark.controlWorkMark != null) {
        totalControlWorkMarks += mark.controlWorkMark!;
        controlWorkCount++;
        totalAllMarks += mark.controlWorkMark!;
        allMarksCount++;
      }
      if (mark.labWorkMark != null) {
        totalLabWorkMarks += mark.labWorkMark!;
        labWorkCount++;
        totalAllMarks += mark.labWorkMark!;
        allMarksCount++;
      }
      if (mark.classWorkMark != null) {
        totalAllMarks += mark.classWorkMark!;
        allMarksCount++;
      }
    }

    return {
      'home': homeWorkCount > 0 ? totalHomeWorkMarks / homeWorkCount : 0.0,
      'control': controlWorkCount > 0 ? totalControlWorkMarks / controlWorkCount : 0.0,
      'lab': labWorkCount > 0 ? totalLabWorkMarks / labWorkCount : 0.0,
      'overall': allMarksCount > 0 ? totalAllMarks / allMarksCount : 0.0,
    };
  }

  Widget _buildAverageCard(String title, double average, Color color) {
    final averageString = average == 0.0 ? 'Н/Д' : average.toStringAsFixed(2);
    
    return Expanded(
      child: Card(
        color: color.withOpacity(0.8),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                averageString,
                style: const TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12, 
                  color: Colors.white70
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главное меню'),
      ),
      body: FutureBuilder<List<Mark>>(
        future: _marksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<String, double> averages = {};
          if (snapshot.hasData) {
            averages = _calculateAverages(snapshot.data!);
          }
          
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _buildAverageCard('Ср. Д/Р', averages['home'] ?? 0.0, Colors.red),
                      _buildAverageCard('Ср. К/Р', averages['control'] ?? 0.0, Colors.green),
                      _buildAverageCard('Ср. Л/Р', averages['lab'] ?? 0.0, Colors.purple),
                      _buildAverageCard('Ср. Общая', averages['overall'] ?? 0.0, Colors.blue),
                    ],
                  ),
                ),

                // Основное меню
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Выберите раздел:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.school),
                          label: const Text('Оценки и Посещаемость'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MarksAndProfileScreen(token: widget.token),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Расписание'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ScheduleScreen(token: widget.token),)
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}