import 'package:flutter/material.dart';
import '../settings/FileSettings.dart' as config;


String? FemilyFont = config.FONT_NAME;

  String? _selectedTheme;
  List<String> themes = ['Светлая', 'Системная', 'Темная'];



  String? _selectedLanges;
  final List<String> Langes = ['Русский', 'Англисский', 'Казахский'];

    String? _selectedFONT_NAME;
  final List<String> Fonts = ['Time New Roman', 'Consolas', 'Roboto','Comic Sans'];

  String? _pathSettengs;
  final List<String> Pathes = ['Все', 'Только об парах', 'Только бо оценках', 'Только бо оценках о студенте', 'Только о наградах', 'Только напоминания о задниях'];

class ScreenSettengs extends StatefulWidget {
  const ScreenSettengs({super.key});
  

  @override
  State<ScreenSettengs> createState() => _ScreenSettengs();

  
 
}

class _ScreenSettengs extends State<ScreenSettengs> 
{


  void Reggs()
  {
    if (config.getValue("Application", "THEM") == 'light')
   {
      _selectedTheme = 'Светлая';
   } else if (config.getValue("Application", "THEM") == 'System') 
   {
    _selectedTheme = 'Системная';
   } 
   else 
   {
     _selectedTheme = 'Темная';
   }

    if (config.getValue("Application", "LANGUAGE") == 'kz')
   {
      _selectedLanges = 'Казахский';
   } else if (config.getValue("Application", "LANGUAGE") == 'en') 
   {
      _selectedLanges = 'Англисский';
   } 
   else 
   {
     _selectedLanges = 'Русский';
   }

  }
  
@override

Widget build(BuildContext context) {
 
  String? FF = config.FONT_NAME;
  
  Reggs();

  
  return Scaffold(
    appBar: AppBar(title: const Text('Настройки')),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Тема",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: FF,
                  ),
                ),
              ),
              DropdownButton<String>
              (
                value: _selectedTheme,
                items: themes.map((theme) => 
                DropdownMenuItem(
                          value: theme,
                          child: Text(theme),
                        )
                    )
                    .toList(),
                onChanged: (newValue) 
                {
                   
                  setState(() {
                      
                     if (newValue == 'Светлая') 
                     {
                      config.setValue("Application", "THEM", 'light');
                    } else if (newValue == 'Системная') {
                      config.setValue("Application", "THEM", 'System');
                    } else {
                      config.setValue("Application", "THEM", 'Dark');
                    }

                    _selectedTheme = newValue;

                    build(context);
                    config.Conect();
                    config.ThemeDate();
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Языки",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  //  fontFamily: FF, ябуууууучие шрифты
                  ),
                ),
              ),
              DropdownButton<String>(
                value: _selectedLanges,
                items: Langes.map((lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                        ))
                    .toList(),
                onChanged: (newValue) 
                {
                  setState(() {
                    Reggs();

                    _selectedLanges = newValue;

                    if (newValue == 'Англисский') 
                    {
                      config.setValue("Application", "LANGUAGE", 'en');
                    } else if (newValue == 'Казахский') {
                      config.setValue("Application", "LANGUAGE", 'kz');
                    } else {
                      config.setValue("Application", "LANGUAGE", 'ru');
                    }

                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Шрифт",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: FF,
                  ),
                ),
              ),
              DropdownButton<String>(
                value: _selectedFONT_NAME,
                items: Fonts
                    .map((font) => DropdownMenuItem(
                          value: font,
                          child: Text(font),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedFONT_NAME = newValue;
                    if (_selectedFONT_NAME == 'Roboto') {
                      config.setValue("Application", "FONT_NAME", 'Roboto');
                    } else if (_selectedFONT_NAME == 'Consolas') {
                      config.setValue("Application", "FONT_NAME", 'Consolas');
                    } else if (_selectedFONT_NAME == 'Comic Sans') {
                      config.setValue("Application", "FONT_NAME", 'Comic Sans');
                    } else {
                      config.setValue("Application", "FONT_NAME", 'Time New Roman');
                    }
                    // Примените изменение шрифта сразу тут
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Административное",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: FF,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  TextEditingController _codeController = TextEditingController();

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Введите код Администрации"),
                        content: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            child: TextField(controller: _codeController),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                // Обработка кода и закрытие диалога
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"))
                        ],
                      );
                    },
                  );
                },
                child: Text("Введите код"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}