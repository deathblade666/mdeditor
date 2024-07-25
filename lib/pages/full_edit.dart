import 'dart:core';
import 'package:flutter/material.dart';
import 'package:mdeditor/pages/textfield.dart';
import 'package:mdeditor/pages/menu.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => editorState();
}

// ignore: camel_case_types
class editorState extends State<Editor> {
  String contents = '';
  String file = '';
  TextEditingController OpenFile = TextEditingController();
  String fileContent = '';
  String NameofFile = '';

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void mdText(String value) {
    setState(() {
     contents = value;      
    });
  }

  void loadedFile(fileAsString){
    setState(() {
      file = fileAsString;
    });
  }

  void setFileName(fileName){
    setState(() {
      NameofFile = fileName;
    });
  }
  void fullEdit(fullEdit){
    if (fullEdit = true){
      bool _full = true;
    } else {
      bool _full = false;
    }
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
            child: mdtextfield(OpenFile, fileContent,ontextchanged: mdText ),
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
                  const Text("20"),
                  Menu(onFileLoad: loadedFile, contents, OpenFile, onfileName: setFileName, onModeToggle: fullEdit,),
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
