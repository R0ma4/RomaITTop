import 'package:flutter/material.dart';
import 'package:journal_mobile/debug/model_work_file/SYSTEM_WORK.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/menu_screen.dart';
import 'screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'settings/FileSettings.dart';
import 'debug/page_admin.dart';
import 'debug/logi.dart'; // Логирование (работает на божьей помощи)

String appVersion = "";
String BildingVersion = "";
String LANGUAGE_ELEMENT = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    appVersion = await getValue('Application', 'APP_VERSION');
    BildingVersion = await getValue('Application', 'VERSION_APP');
    LANGUAGE_ELEMENT = await getValue('Application', 'LANGUAGE_ELEMENT');
  
  Console.Write(
  "\nLANGUAGE = ${LANGUAGE_ELEMENT}"+
  "\nVirsion: ${appVersion}"+
  "\nApp Virsion: ${BildingVersion}");

  await initializeDateFormatting(await getValue('Application', 'LANGUAGE_ELEMENT').toString(), null);
  //  await setValue('Application', 'APP_VERSION',"\"apps\""); Обновление значений кофигрупации
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<String?> _getToken() async {

   
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
    
  }

Widget Bilder_App(BuildContext context) 
{
   Debug.log("Hello, World");
  Console.Write("${appVersion.runtimeType} ${appVersion.toString()}");
  if (appVersion.toString() == 'debug'.toString()) 
  {
    return PageAdmin();
  }
  else if (appVersion.toString() == 'app'.toString()) 
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return MainMenuScreen(token: snapshot.data!);
          }
          return const LoginScreen();
        },
      ),
       
    );
  }
  else
  {
      return CircularProgressIndicator();
  }
}


  @override
  Widget build(BuildContext context) {
    return Bilder_App(context);
  }
}




/*
Widget Bilder_App() 
{
  if (appVersion == "debug") 
  {
    return PageAdmin();
  }
  else if (appVersion == 'app') 
  {
    return FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return MainMenuScreen(token: snapshot.data!);
          }
          return const LoginScreen();
        },
      );
  }
  else
  {
   return CircularProgressIndicator();  
  }
}
 appVersion = await getValue('Application', 'APP_VERSION');
 */