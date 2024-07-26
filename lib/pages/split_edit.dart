import 'dart:core';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:mdeditor/pages/menu.dart';
import 'package:mdeditor/pages/preview.dart';
import 'package:mdeditor/pages/textfield.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => editorState();
}

// ignore: camel_case_types
class editorState extends State<Editor> {
  String contents = '';
  String fileContent = '';
  String NameofFile = '';
  bool _full = true;
  List words = [];
  int wordCount = 0;
  TextEditingController OpenFile = TextEditingController();

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void mdText(String value) {
    setState(() {
      contents = value;
      final List wordList = value.split(' ');
      wordCount = wordList.length;
    });
  }

  void loadedFile(fileContent){
    setState(() {
      OpenFile.text = fileContent;
      contents = fileContent;
      final List wordList = OpenFile.text.split(' ');
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
          const Padding(padding: EdgeInsets.only(top: 5)),
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
                  Menu(onFileLoad: loadedFile, contents, OpenFile, onfileName: setFileName, onModeToggle: switchViewMode,),
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
