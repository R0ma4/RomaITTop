import 'package:flutter/material.dart';
import '../models/days_element.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

DateTime getMonday(DateTime date) {
  final d = DateTime(date.year, date.month, date.day);
  final day = d.weekday;
  final diff = day - 1; 
  return d.subtract(Duration(days: diff));
}

DateTime getSunday(DateTime date) {
  final d = getMonday(date);
  return d.add(const Duration(days: 6));
}

// API (YYYY-MM-DD)
String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

class ScheduleScreen extends StatefulWidget {
  final String token;
  const ScheduleScreen({super.key, required this.token});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ApiService _apiService = ApiService();
  DateTime _currentDate = DateTime.now(); 
  late Future<List<ScheduleElement>> _scheduleFuture;

  @override
  void initState() {
    super.initState();
    _scheduleFuture = _loadSchedule(); 
  }

  Future<List<ScheduleElement>> _loadSchedule() {
    final monday = getMonday(_currentDate);
    final sunday = getSunday(_currentDate);
    
    return _apiService.getSchedule(
        widget.token,
        formatDate(monday),
        formatDate(sunday),
    );
  }

  void _changeWeek(int delta) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: delta * 7));
      _scheduleFuture = _loadSchedule(); 
    });
  }
  Widget _buildScheduleDay(ScheduleElement element) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${element.startedAt} - ${element.finishedAt}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            element.subjectName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(element.teacherName),
              Text('Аудитория: ${element.roomName}'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monday = getMonday(_currentDate);
    final sunday = getSunday(_currentDate);
    final weekRange = '${DateFormat('dd.MM').format(monday)} - ${DateFormat('dd.MM').format(sunday)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => _changeWeek(-1),
                ),
                Text(
                  weekRange,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () => _changeWeek(1),
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<ScheduleElement>>(
              future: _scheduleFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Ошибка загрузки: ${snapshot.error.toString()}'));
                }
                
                final schedule = snapshot.data ?? [];
                if (schedule.isEmpty) {
                  return const Center(child: Text('На эту неделю занятий нет'));
                }
                final groupedSchedule = <String, List<ScheduleElement>>{};
                for (var element in schedule) {
                  if (!groupedSchedule.containsKey(element.date)) {
                    groupedSchedule[element.date] = [];
                  }
                  groupedSchedule[element.date]!.add(element);
                }
                final sortedDays = groupedSchedule.keys.toList()..sort();
                
                return ListView.builder(
                  itemCount: sortedDays.length,
                  itemBuilder: (context, index) {
                    final dayKey = sortedDays[index];
                    final lessons = groupedSchedule[dayKey]!;
                    
                    final date = DateTime.parse(dayKey);
                    final dayName = DateFormat('EEEE', 'ru_RU').format(date);
                    final formattedDate = '${dayName[0].toUpperCase()}${dayName.substring(1)}, ${DateFormat('dd.MM').format(date)}';
                    
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ),
                          ...lessons.map(_buildScheduleDay).toList(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}