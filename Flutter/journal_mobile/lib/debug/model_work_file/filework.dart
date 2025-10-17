// Данный модуль, создан для более упрощённого создания систему Log-ирования. 

import 'dart:io';
import 'package:path_provider/path_provider.dart';

  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _createFile(String fileName) async {
  final path = await _localPath;
  final file = File('$path/$fileName');
  return file;
}

Future<void> _writeToFile(String content, String fileName) async {
  final file = await _createFile(fileName);
  await file.writeAsString(content);
}

Future<String> _readFromFile(String fileName) async {
  final file = await _createFile(fileName);
  return await file.readAsString();
}
