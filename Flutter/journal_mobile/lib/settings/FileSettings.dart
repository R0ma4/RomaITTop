import 'package:ini/ini.dart';
import 'dart:io';

// Application - это основные настройки приложения, 
// Систкменая тема, тип отрисовии приложения. и таму подобное.

String? VERSION_APP = "";
String? VERSION_NAME = "";
String? APP_VERSION = "";
String? VIBRO = "";

void Test() async {

  var file = File('C:/Users/Asus/Documents/Journal_Mobile/Journal_Mobile/Flutter/journal_mobile/lib/settings/config.conf');
  var content = await file.readAsString();
  var config = Config.fromString(content);

print("TEST_START");
  print(config.get('Application', 'VIBRO'));
  print(config.get('debug', 'ERROR_APP'));
print("TEST_STOP");
}


Future<String> getValue(String key, String value) async
{
 var file = File('C:/Users/Asus/Documents/Journal_Mobile/Journal_Mobile/Flutter/journal_mobile/lib/settings/config.conf');
  var content = await file.readAsString();
  var config = Config.fromString(content);

  return config.get(key, value) ?? '';
}

Future<void> setValue(String key, String value, String newValue) async {
  var file = File('C:/Users/Asus/Documents/Journal_Mobile/Journal_Mobile/Flutter/journal_mobile/lib/settings/config.conf');
  var content = await file.readAsString();

  var config = Config.fromString(content);
  config.set(key, value, newValue); 

  await file.writeAsString(config.toString());  
}