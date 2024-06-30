import 'dart:core';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mdeditor/pages/preview.dart';
import 'package:mdeditor/pages/textfield.dart';
import 'package:mdeditor/pages/functions/files.dart';


 enum Menu {
  save, 
  open,
  fileInfo,
  switchTheme,
  switchView,
  enableWorkCount
  }

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => editorState();
}

// ignore: camel_case_types
class editorState extends State<Editor> {
  String contents = '';

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void mdText(String value) {
    setState(() {
     contents = value;      
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
            child: Renderer(contents),
          ),
          Expanded(
            child: mdtextfield(ontextchanged: mdText,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                padding: const EdgeInsets.only(left: 5),
                elevation: 0,
                color: Theme.of(context).primaryColor,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                  const PopupMenuItem<Menu>(
                    value: Menu.save,
                    //nTap: save,
                    child: Text("Save"),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.open,
                    //onTap: openFile,
                    child: Text("Open"),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.fileInfo,
                    //onTap: openFile,
                    child: Text("File Info"),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.switchView,
                    //onTap: openFile,
                    child: Text("Switch Mode"),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.switchTheme,
                    //onTap: openFile,
                    child: Text("Change Theme"),
                  ),   
                ]
              )
            ]
          ),
        ]
      ),
    );
  }
}
