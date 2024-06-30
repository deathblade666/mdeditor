import 'dart:core';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:markdown/markdown.dart' as md;
//import 'package:markdown_editor_plus/markdown_editor_plus.dart';
//import 'package:markdown_editor_plus/widgets/markdown_parse_body.dart';
import 'package:mdeditor/pages/preview.dart';
import 'package:mdeditor/pages/textfield.dart';

class Editor extends StatefulWidget {
  const Editor(contents, {super.key});

  @override
  State<Editor> createState() => editorState();

}

// ignore: camel_case_types
class editorState extends State<Editor> {
  final TextEditingController myController = TextEditingController();
  String contents = ' ';
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void mdText(String) {
    setState(() {
      contents = myController.text;      
    });

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Renderer(),
          ),
          Expanded(
            child: mdtextfield(mdtextfield),
          ),
        ]
      ),
    );
  }
}
