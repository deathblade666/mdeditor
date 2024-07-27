import 'dart:core';
import 'package:flutter/material.dart';
import 'package:mdeditor/pages/menu.dart';
import 'package:mdeditor/pages/preview.dart';
import 'package:mdeditor/pages/textfield.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => editorState();
}

class editorState extends State<Editor> {
  String contents = '';
  String fileContent = '';
  String NameofFile = '';
  bool _full = fullEdit;
  int wordCount = 0;
  TextEditingController OpenFile = TextEditingController();

  void mdText(String value) {
    setState(() {
      contents = value;
      List wordList = value.split(' ');
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

  void switchViewMode(fullEdit){
    setState(() {
      _full=fullEdit;
    });
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
                  Text("$wordCount"),
                  Menu(onFileLoad: loadedFile, contents, OpenFile, onfileName: setFileName, onModeToggle: switchViewMode, wordCount),
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
