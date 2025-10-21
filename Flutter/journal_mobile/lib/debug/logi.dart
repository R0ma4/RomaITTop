import 'dart:io';

import 'package:flutter/material.dart';

import '../debug/model_work_file/SYSTEM_WORK.dart';
import '../debug/model_work_file/filework.dart' as FILE;
import 'package:journal_mobile/settings/FileSettings.dart' as data;
import '../settings/FileSettings.dart';

import 'package:logger/logger.dart';

enum MessegeLogType
{
  Standaer,
  Error,
  FotalError,
}

class Debug
{
static Future<void> log(String message, [MessegeLogType type = MessegeLogType.Standaer ,bool flag = true ]) async 
{
      
  }


static Future<void> DelaiteLog() async
{
String LOG_DATA = await getValue("Application", "LOG_DATA");

      File file = File(LOG_DATA);
      file.delete();
}
}
