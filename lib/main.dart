// ignore_for_file: prefer_const_constructors
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:mdeditor/pages/split_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs));
}


final _defaultDarkColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.indigo, brightness: Brightness.dark);
final _defaultLightColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.indigo);


class MyApp extends StatefulWidget{
  MyApp(this.prefs,{super.key});
  SharedPreferences prefs;

  @override
  State<MyApp> createState() => MyAppState(prefs);
}
  
class MyAppState extends State<MyApp> {
  MyAppState(this.prefs);
  var selectedTheme = '';
  var theme;
  final SharedPreferences prefs;

  @override
  void initState() {
    onStart();
    super.initState();
  }

  void onStart(){
    prefs.reload();
    String? selectedTheme = prefs.getString('selectedTheme');
    setTheme(selectedTheme);
  }

  void setTheme(selectedTheme) async {
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
      //if (selectedTheme == "black"){
        //selectedTheme = blackTheme;
       // theme = ThemeMode.dark;
     // }
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme, ) {
      
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Editor(onThemeSelect: setTheme,prefs),
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