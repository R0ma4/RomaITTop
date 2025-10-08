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
  // Загружаем оценки один раз
  late Future<List<Mark>> _marksFuture; 

  @override
  void initState() {
    super.initState();
    _marksFuture = _apiService.getMarks(widget.token);
  }

  // === 1. ЛОГИКА ВЫЧИСЛЕНИЯ СРЕДНИХ ОЦЕНОК ===
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
  
  // === 2. ЛОГИКА ВЫЧИСЛЕНИЯ СТАТИСТИКИ ПОСЕЩАЕМОСТИ ===
  Map<String, double> _calculateAttendance(List<Mark> marks) {
    if (marks.isEmpty) {
      return {'total': 0, 'attended': 0, 'late': 0, 'missed': 0, 'attended_percent': 0.0, 'late_percent': 0.0, 'missed_percent': 0.0};
    }

    final int totalLessons = marks.length;
    int attendedCount = 0;  // statusWas 1 (был) или 2 (опоздал)
    int lateCount = 0;      // statusWas 2 (опоздал)
    int missedCount = 0;    // statusWas 0 (не был)

    for (var mark in marks) {
      if (mark.statusWas == 1) {
        attendedCount++;
      } else if (mark.statusWas == 2) {
        attendedCount++;
        lateCount++;
      } else if (mark.statusWas == 0) {
        missedCount++;
      }
    }
    
    return {
      'total': totalLessons.toDouble(),
      'attended': attendedCount.toDouble(),
      'attended_percent': (attendedCount / totalLessons) * 100,
      'late': lateCount.toDouble(),
      'late_percent': (lateCount / totalLessons) * 100,
      'missed': missedCount.toDouble(),
      'missed_percent': (missedCount / totalLessons) * 100,
    };
  }

  // === 3. ВИДЖЕТЫ КАРТОЧЕК ===
  
  // Вспомогательный виджет для отображения карточки СРЕДНЕЙ оценки
  Widget _buildMarkAverageCard(String title, double average, Color color) {
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

  // Новый вспомогательный виджет для отображения статистики ПОСЕЩАЕМОСТИ
  Widget _buildAttendanceStatCard(String title, double count, double percentage, Color color) {
    final countString = count.toInt().toString();
    final percentString = percentage.toStringAsFixed(2);
    
    String mainText;
    
    if (title == 'Всего пар') {
      mainText = countString;
    } else {
      // Формат: "741 (97.12%)"
      mainText = '$countString (${percentString}%)';
    }

    return Expanded(
      child: Card(
        color: color.withOpacity(0.9),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mainText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16, // Немного меньше, чтобы вместился процент
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10, // Меньше шрифт для заголовка
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
          Map<String, double> attendance = {};
          
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final marks = snapshot.data!;
            averages = _calculateAverages(marks);
            attendance = _calculateAttendance(marks); 
          }
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ЗАГОЛОВОК ДЛЯ ОЦЕНОК
                 const Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 4.0, left: 12.0, right: 12.0),
                  child: Text(
                    'Средние оценки',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                
                // 1. Карточки средних оценок
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      _buildMarkAverageCard('Ср. Д/Р', averages['home'] ?? 0.0, Colors.red),
                      _buildMarkAverageCard('Ср. К/Р', averages['control'] ?? 0.0, Colors.green),
                      _buildMarkAverageCard('Ср. Л/Р', averages['lab'] ?? 0.0, Colors.purple),
                      _buildMarkAverageCard('Ср. Общая', averages['overall'] ?? 0.0, Colors.blue),
                    ],
                  ),
                ),
                
                // ЗАГОЛОВОК ДЛЯ ПОСЕЩАЕМОСТИ
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 4.0, left: 12.0, right: 12.0),
                  child: Text(
                    'Статистика посещаемости',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                
                // 2. Карточки посещаемости
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      // Всего пар (без процента)
                      _buildAttendanceStatCard('Всего пар', attendance['total'] ?? 0.0, 0.0, Colors.grey.shade700),
                      // Посещено
                      _buildAttendanceStatCard('Посещено Пар', attendance['attended'] ?? 0.0, attendance['attended_percent'] ?? 0.0, Colors.green.shade700),
                      // Опозданий
                      _buildAttendanceStatCard('Опозданий', attendance['late'] ?? 0.0, attendance['late_percent'] ?? 0.0, Colors.orange.shade700),
                      // Пропусков
                      _buildAttendanceStatCard('Пропусков', attendance['missed'] ?? 0.0, attendance['missed_percent'] ?? 0.0, Colors.red.shade700),
                    ],
                  ),
                ),

                // Основное меню
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Выберите раздел:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.school),
                          label: const Text('Оценки и Профиль'),
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
                          label: const Text('Расписание (В разработке)'),
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