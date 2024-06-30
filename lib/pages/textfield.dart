import 'dart:core';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:markdown/markdown.dart' as md;
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
//import 'package:markdown_editor_plus/widgets/markdown_parse_body.dart';
//import 'package:mdeditor/pages/preview.dart';

class mdtextfield extends StatefulWidget {
  const mdtextfield(contents, {super.key});

  @override
  State<mdtextfield> createState() => mdtextfieldState();

}

// ignore: camel_case_types
class mdtextfieldState extends State<mdtextfield> {
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
    return Container(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white)
          ),
          padding: const EdgeInsets.all(15),
          child: MarkdownAutoPreview(
            controller: myController,
            emojiConvert: true,
            onChanged: mdText,
            enableToolBar: true,
            autoCloseAfterSelectEmoji: false,
            showEmojiSelection: true,
          ),
        ),
      ),
    );
  }
}