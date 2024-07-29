import 'dart:core';
import 'package:flutter/material.dart';
import 'package:mdeditor/pages/menu.dart';
import 'package:mdeditor/pages/preview.dart';
import 'package:mdeditor/pages/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editor extends StatefulWidget {
  const Editor({super.key, required this.onThemeSelect});
  final void Function(String selectedtheme) onThemeSelect;

  @override
  State<Editor> createState() => editorState();
}

class editorState extends State<Editor> {
  String contents = '';
  String fileContent = '';
  String NameofFile = '';
  bool _full = fullEdit;
  bool showWordCount = WordCount;
  int wordCount = 0;
  var theme = ThemeMode.system;
  TextEditingController OpenFile = TextEditingController();

@override
  void initState() {
    onStart();
    super.initState();
  }

  void onStart() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? fullEdit = prefs.getBool("ViewMode");
    final bool? WordCount = prefs.getBool('DisplayWordCount');
    enableWordCount(WordCount);
    switchViewMode(fullEdit);
  }

  void mdText(String inputText) {
    setState(() {
      contents = inputText;
      List wordList = inputText.split(' ');
      wordCount = wordList.length;
    });
  }

  void loadedFile(fileContent){
    setState(() {
      OpenFile.text = fileContent;
      contents = fileContent;
      List wordList = OpenFile.text.split(' ');
      wordCount = wordList.length;
    });
  }

  void setFileName(fileName){
    setState(() {
      NameofFile = fileName;
    });
  }

  void switchViewMode(fullEdit) async {
    setState(() {
      _full=fullEdit!;
    });
  }

  void enableWordCount(WordCount) async {
    setState(() {
      showWordCount=WordCount!;
    });
  }

  void setTheme(selectedTheme){
    widget.onThemeSelect(selectedTheme);
  }
      

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        toolbarHeight: 2,
      ),
      body: Column(
        children: [
          Visibility(
            visible: _full,
            child:Expanded(
              flex: 2,
              child: Renderer(OpenFile, contents),
            ),
          ),
          Expanded(
            child: mdtextfield(OpenFile, fileContent,ontextchanged: mdText,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 15)),
                  Text(NameofFile),
                ],
              ),
              Row(
                children: [
                  Visibility(
                    visible: showWordCount,
                    child: Text("$wordCount"),
                  ),
                  Menu(onFileLoad: loadedFile, contents, OpenFile, onfileName: setFileName, onModeToggle: switchViewMode, wordCount, onEnableWordCount: enableWordCount,onThemeSelected: setTheme,),
                  const Padding(padding: EdgeInsets.only(right: 15)),
                ],
              ),
            ]
          ),
        ]
      ),
    );
  }
}
