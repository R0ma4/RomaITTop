import 'dart:io';

import 'package:flutter/material.dart';

import '../debug/model_work_file/SYSTEM_WORK.dart';
import '../debug/model_work_file/filework.dart' as FILE;
import 'package:journal_mobile/settings/FileSettings.dart' as data;
import '../settings/FileSettings.dart';


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
      File file = File("C:/Users/Asus/Documents/Journal_Mobile/Journal_Mobile/Flutter/journal_mobile/ib/Data/LoginEventApp.txt");
      file.delete();

    String MESSEGE = "";
    try {
      TimeOfDay ofDay = TimeOfDay(hour: 00, minute: 00);

      switch(MessegeLogType)
      {
        case MessegeLogType.Standaer: MESSEGE += "[√][Log] "; break;
        case MessegeLogType.Error: MESSEGE += "[X][Error] "; break;
        case MessegeLogType.FotalError: MESSEGE += "[!][FotalError] "; break;
      }

      MESSEGE += message;
      
      if(flag) {MESSEGE += " [Time: ${ofDay.hour}:${ofDay.minute}]";}
      else{MESSEGE += " []";}

      File file = File("C:/Users/Asus/Documents/Journal_Mobile/Journal_Mobile/Flutter/journal_mobile/ib/Data/LoginEventApp.txt");

      if (await file.exists()) {
        String content = await file.readAsString();
        
        await file.writeAsString(content + "\n" + MESSEGE, mode: FileMode.append);
      } else {

        await file.create();
        await file.writeAsString(MESSEGE);
      }
    } catch (e) {

      Console.WriteToObject(e);
    }
  }


static Future<void> DelaiteLog() async
{
String LOG_DATA = await getValue("Application", "LOG_DATA");

      File file = File(LOG_DATA);
      file.delete();
}
}
