import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mark.dart';
import '../models/user_data.dart';
import '../models/days_element.dart';
import 'package:shared_preferences/shared_preferences.dart';

// не трогать КОД - НИКОМУ кроме КЕЙСИ (Дианы) !!! НИЗАЧТО (сломаю пальцы и в жопу засуну)
class ApiService {
  final String _baseUrl = "https://msapi.top-academy.ru/api/v2"; 

  Future<String?> _reauthenticate() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (username == null || password == null) {
      return null; 
    }

    final newToken = await login(username, password); 
    
    if (newToken != null) {
      await prefs.setString('token', newToken); // новый токен
    }
    return newToken;
  }

  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Referer': 'https://journal.top-academy.ru', 
      },
      body: jsonEncode({
        'username': username, 
        'password': password,
        'application_key': 
          '6a56a5df2667e65aab73ce76d1dd737f7d1faef9c52e8b8c55ac75f565d8e8a6',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token']; 
    } else {
      print("Login failed: ${response.statusCode}");
      print("Response body: ${response.body}"); 
      return null;
    }
  }

  Future<List<Mark>> getMarks(String token) async {
    var response = await http.get(
      Uri.parse('$_baseUrl/progress/operations/student-visits'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Referer': 'https://journal.top-academy.ru', 
      },
    );

    if (response.statusCode == 401) { 
      final newToken = await _reauthenticate();
      if (newToken != null) {
        response = await http.get(
          Uri.parse('$_baseUrl/progress/operations/student-visits'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newToken',
            'Referer': 'https://journal.top-academy.ru',
          },
        );
      }
    }
    if (response.statusCode == 200) {
      final List<dynamic> marksData = jsonDecode(response.body);
      return marksData.map((json) => Mark.fromJson(json)).toList();
    } else {
      print("Failed to load marks: ${response.statusCode}");
      throw Exception('Failed to load marks');
    }
  }
  
    Future<UserData> getUser(String token) async {
    var response = await http.get(
      Uri.parse('$_baseUrl/settings/user-info'), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Referer': 'https://journal.top-academy.ru', 
      },
    );

    if (response.statusCode == 401) {
      final newToken = await _reauthenticate();
      if (newToken != null) {
        response = await http.get(
          Uri.parse('$_baseUrl/settings/user-info'), 
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newToken',
            'Referer': 'https://journal.top-academy.ru', 
          },
        );
      }
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserData.fromJson(data);
    } else {
      print("Failed to load user data: ${response.statusCode}");
      throw Exception('Failed to load user data');
    }
  }

  Future <List<ScheduleElement>> getSchedule(String token, String dateFrom, String dateTo) async { 
    final String _baseUrl = "https://msapi.top-academy.ru/api/v2";
    
    var response = await http.get(
      Uri.parse('$_baseUrl/schedule/operations/get-by-date-range?date_start=$dateFrom&date_end=$dateTo'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Referer': 'https://journal.top-academy.ru',
      },
    );

    if (response.statusCode == 401) {
      final newToken = await _reauthenticate();
      if (newToken != null) {
        response = await http.get(
          Uri.parse('$_baseUrl/schedule/operations/get-by-date-range?date_start=$dateFrom&date_end=$dateTo'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newToken',
            'Referer': 'https://journal.top-academy.ru',
          },
        );
      }
    }

    if (response.statusCode == 200) {
      final List<dynamic> scheduleData = jsonDecode(response.body); 
      
      return scheduleData
          .map((json) => ScheduleElement.fromJson(json as Map<String, dynamic>))
          .toList();
          
    } else {
      print("Failed to load schedule: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load schedule');
    }
  }
}