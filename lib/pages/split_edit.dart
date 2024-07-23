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

// ignore: camel_case_types
class editorState extends State<Editor> {
  String contents = '';
  String fileContent = '';
  String NameofFile = '';
  TextEditingController OpenFile = TextEditingController();

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void mdText(String value) {
    setState(() {
     contents = value;      
    });
  }

  void loadedFile(fileContent){
    setState(() {
      OpenFile.text = fileContent;
      contents = fileContent;
    });
  }

  void setFileName(fileName){
    setState(() {
      NameofFile = fileName;
      print(NameofFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        toolbarHeight: 2,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Renderer(OpenFile, contents),
          ),
          Expanded(
            child: mdtextfield(OpenFile, fileContent,ontextchanged: mdText,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Open File: $NameofFile"),
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: Menu(onFileLoad: loadedFile, contents, OpenFile, onfileName: setFileName),
              ),
            ]
          ),
        ]
      ),
    );
  }
}
