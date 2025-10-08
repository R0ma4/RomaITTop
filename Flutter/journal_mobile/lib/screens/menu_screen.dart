import 'package:flutter/material.dart';
import 'marks_and_profile_screen.dart';
import 'schedule_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final String token;
  const MainMenuScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главное меню'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                      builder: (_) => MarksAndProfileScreen(token: token),
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
                      builder: (_) => ScheduleScreen(token: token),)
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}