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
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.indigo),
                const SizedBox(width: 5),
                Text(
                  '${element.startedAt.substring(0, 5)} - ${element.finishedAt.substring(0, 5)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.indigo),
                ),
                const Spacer(),
                Text(
                  'Пара ${element.lesson}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 12, thickness: 1),
            Text(
              element.subjectName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    element.teacherName,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  element.roomName,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
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
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                          child: Text(
                            formattedDate,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
                          ),
                        ),
                        ...lessons.map(_buildScheduleDay).toList(),
                        const SizedBox(height: 16),
                      ],
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