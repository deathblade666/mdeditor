// ignore_for_file: prefer_const_constructors
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:mdeditor/pages/split_edit.dart';

void main() async {
  runApp(MyApp());
}

final _defaultDarkColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.indigo, brightness: Brightness.dark);
final _defaultLightColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.indigo);

class MyApp extends StatefulWidget{
  const MyApp({super.key});


  @override
  State<MyApp> createState() => MyAppState();
}
  
class MyAppState extends State<MyApp> {
  MyAppState();
  String selectedTheme = '';
  var theme;


  void setTheme(selectedTheme){
    setState(() {
      if (selectedTheme == "system"){
        theme = ThemeMode.system;
      }
      if (selectedTheme == "light"){
        theme = ThemeMode.light;
      }
      if (selectedTheme == "dark"){
        theme = ThemeMode.dark;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Editor(onThemeSelect: setTheme,),
        theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
              useMaterial3: true,
            ),
        themeMode: theme,
        );
    });
  }
}