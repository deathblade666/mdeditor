// ignore_for_file: prefer_const_constructors
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:mdeditor/pages/split_edit.dart';

void main() {
  runApp(const MyApp());
}

final _defaultDarkColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.indigo, brightness: Brightness.dark);
final _defaultLightColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.indigo);

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  

  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Editor(),
        theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
              useMaterial3: true,
            ),
        //themeMode: ThemeMode.dark,
        // themeMode: ThemeMode.light,
        );
    });
  }  
}