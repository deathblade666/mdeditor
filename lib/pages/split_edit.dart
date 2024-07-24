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
          Padding(padding: EdgeInsets.only(top: 5)),
          Expanded(
            flex: 2,
            child: Renderer(OpenFile, contents),
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
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
                  Text("20"),
                  Menu(onFileLoad: loadedFile, contents, OpenFile, onfileName: setFileName),
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
