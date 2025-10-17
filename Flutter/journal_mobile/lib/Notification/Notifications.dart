
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// Для логирования в ФАЙЛ 

// https://300.ya.ru/zdIApWho
enum NotificationType 
{
  StartApp,
  Update, // Какое либо обновление (пары)
  Coolege_Event, // Событие в колледже
  Evaluation,
}
class Notifications
{
  get flutterLocalNotificationsPlugin => null;


Future init() async {
    try
    {
      late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    // Инициализация для Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Инициализация для iOS
   // const IOSInitializationSettings initializationSettingsIOS =
    //    IOSInitializationSettings();

    // Общие настройки
    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
       // iOS: initializationSettingsIOS
       );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
   
    }
    catch (e)
    {

    }
  }

   Future showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );


void _Notifications(NotificationType Type)
  {
    
    String TEXT_MESSEGE = "";
    String Lengeg = "RU-ru";
    NotificationType t = Type;

    switch(Lengeg)
    {
      case"RU-ru": 
      switch(t)
      {
      case NotificationType.StartApp:
        TEXT_MESSEGE = "Вы запустили приложение!";
        break;
       case NotificationType.Coolege_Event:
        TEXT_MESSEGE = "У КОЛЕДЖА СОБЫТИЕ! ЗАХОДИ НА САЙТ, ЧТО-БЫ ОЗНАКОМИТЬСЯ!";
        break;
      case NotificationType.Update:
        TEXT_MESSEGE = "Обновление! У вашего расписания, произошли изменения! Заходи, что-бы узнать что, новго!";
        break;
      case NotificationType.Evaluation:
        TEXT_MESSEGE = "У вас новая оценка";
        break;
      }
      break;
    } 
  }
}
}