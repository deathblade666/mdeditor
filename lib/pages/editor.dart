import 'dart:core';
//import 'dart:js_interop';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:markdown/markdown.dart' as md;
//import 'package:markdown_editor_plus/markdown_editor_plus.dart';
//import 'package:markdown_editor_plus/widgets/markdown_parse_body.dart';
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

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void mdText(String value) {
    setState(() {
     contents = value;      
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Renderer(contents),
          ),
          Expanded(
            child: mdtextfield(ontextchanged: mdText,),
          ),
        ]
      ),
    );
  }
}
