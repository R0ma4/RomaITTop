import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../debug/logi.dart';
import '../debug/model_work_file/SYSTEM_WORK.dart';
import '../settings/FileSettings.dart';

class PageAdmin extends StatefulWidget {
  const PageAdmin({super.key});
  
  @override
  State<PageAdmin> createState() => _PageAdmin();
}

String ERROR_APP = "0";
String START_APP = "0";
String FOTAL_ERROR_APP = "0";

  final EmaleMessegeContent = TextEditingController();
  final LogPath = TextEditingController();
  String m = "";
void CheckWifiModul(BuildContext context)  async// Проверка Сети интернет (Мобильная / Обычная)
{
   
   var connectivityResult = await Connectivity().checkConnectivity();

    ERROR_APP = await getValue('debug','FOTAL_ERROR_APP');
    await setValue('debug','FOTAL_ERROR_APP',"app");
    if (connectivityResult == ConnectivityResult.none) 
    {
     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нет подключения к интернету'),
        ),
      ); 
    }
    else
    {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Подключение в норме!'),
        ),
      ); 
    }
}

class _PageAdmin extends State<PageAdmin> 
{
  @override
  Widget build(BuildContext context) 
  {
    try
    {
       return Scaffold
       (
        appBar: AppBar( title: const Text("ПАНЕЛЬ РАЗРАБОТЧИКА"),),
      body: Padding(padding:  const EdgeInsets.all(0.0), 
          child: Column
          (
            children: 
            [

              Center( child: Column(children: [ 
              TextButton(onPressed:() => {}, child: Text("Удалить Log",), ),
              TextButton(onPressed: () => 
              {
                showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Выгрузка Log"),
                   
                      ); })
              }, 
              child: Text("Выгрузить Log")),
              TextButton(onPressed: () => 
              {
                CheckWifiModul(context)
              }, 
              child: 
              Text("Проверить связь с интернетом", selectionColor: Color.fromARGB(255, 155, 155, 155),)),
              // API Test
              TextButton(onPressed: () => {}, child: Text("Проверить свзяь с API")),
              TextButton(onPressed: () => 
              {
                  

              }, child: Text("Перерегестрировать токин")),

              TextButton(onPressed: () => {}, child: Text("Включить Debug версию")),
              TextButton(onPressed: () => {}, child: Text("Выйти из панели разработчика Debug версию")),
              
              ],
            ),
          ),
        Text("Отчёт"),
        Center(
          child: Column(
            children: [
             TextField(
              controller: EmaleMessegeContent,
              decoration: const InputDecoration(labelText: 'Шаблонное сообщение при отправке отчёта'),
              // Доброго времени суток!</nl>Я [FULL_NAME_STUDENT] - [STUDENT_GRUP].</nl>При работе с приложением, произошла ошибка:  [APP_ERROR]. Я прикрепил файил логирования, для ознакомления и решения данной проблеммы [FILE(LOG)]
            ),
          
            Text("Приложение было запущенно: ${START_APP} раз"),
            Text("Из них: ${ERROR_APP} ошибок, ${FOTAL_ERROR_APP} фотальных ошибок"),

              
             
            ],
            
          ),
          
        )
        ],
      ),
    ),
      floatingActionButton: IconButton(onPressed: () => {}, icon: Icon(Icons.exit_to_app), iconSize: 50 ,),
   );
    }
    catch(ex)
    {
      Console.WriteToObject(ex);
      //Debug.log("$ex");
      throw UnimplementedError("${ex}");
    }
  }
}