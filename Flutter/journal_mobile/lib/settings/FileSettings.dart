import 'package:flutter/material.dart';
import 'package:ini/ini.dart';
import 'dart:io';

import 'package:journal_mobile/debug/model_work_file/SYSTEM_WORK.dart';

// Application - это основные настройки приложения, 
// Систкменая тема, тип отрисовии приложения. и таму подобное.

String? VERSION_APP = "";
String? VERSION_NAME = "";
String? APP_VERSION = "";
String? VIBRO = "";
String? FONT_NAME = "";
String? THEMS = "";
String TEXT_MAX_SIZE = "25";
String TEXT_MIN_SIZE = "14";

/// Задаёт переменным нужные пораметры.
void Conect() async {

  var file = File('lib/settings/config.conf');
  var content = await file.readAsString();
  var config = Config.fromString(content);

print("Conect:");
FONT_NAME = await getValue("Application","FONT_NAME");
THEMS = await getValue("Application","THEM");
TEXT_MAX_SIZE = await getValue("Application","TEXT_MAX_SIZE");
TEXT_MIN_SIZE = await getValue("Application","TEXT_MIN_SIZE");

print("Thems "+THEMS.toString());
print("TEXT_MAX_SIZE "+TEXT_MAX_SIZE.toString());
print("TEXT_MIN_SIZE "+TEXT_MIN_SIZE.toString());
print("Conect<end>");
}

/// Тема приложения 
ThemeData ThemeDate()
{
  Conect();


  String tmaxs = TEXT_MAX_SIZE;  
  String tmins = TEXT_MAX_SIZE;  

  double tmeds = ((double.parse(tmaxs) + double.parse(tmins)) / 2 );

  Brightness? thems;
  if(THEMS == 'light'.toString()) { thems = Brightness.light;} 
  else if(THEMS == 'System'.toString()) { thems  = Brightness.light;} // Забрать из системы (пока значение по усмолчанию)
  else { thems  = Brightness.dark;} 

  return ThemeData(
        textTheme: TextTheme(
          // Обыкновенный текст
          bodyLarge: TextStyle(fontSize: tmeds+2, fontFamily: FONT_NAME),
          bodyMedium: TextStyle(fontSize: tmeds, fontFamily: FONT_NAME),
          bodySmall: TextStyle(fontSize: tmeds-2, fontFamily: FONT_NAME),
          // Заголоки
          displayLarge: TextStyle(fontSize: double.parse(tmaxs) + 1.2, fontFamily: FONT_NAME),
          displayMedium:TextStyle(fontSize: double.parse(tmaxs), fontFamily: FONT_NAME),
          displaySmall:TextStyle(fontSize: double.parse(tmaxs) - 1.2, fontFamily: FONT_NAME),
          ),
        primarySwatch: Colors.blue,
        brightness: thems,
      );
}

/// Заберает значение с [key] как имя блока [value] имя переменный, значение которой нужно забрать.
Future<String> getValue(String key, String value) async
{
 var file = File('lib/settings/config.conf');
  var content = await file.readAsString();
  var config = Config.fromString(content);

  return config.get(key, value) ?? '';
}

Future<void> setValue(String key, String value, String newValue) async {
  var file = File('lib/settings/config.conf');
  var content = await file.readAsString();

  var config = Config.fromString(content);
  config.set(key, value, newValue); 

  await file.writeAsString(config.toString());  
}