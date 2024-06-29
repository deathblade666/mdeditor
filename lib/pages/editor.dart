import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:markdown/markdown.dart' as md;
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
//import 'package:markdown_editor_plus/widgets/markdown_parse_body.dart';

//test

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _editorState();

}

// ignore: camel_case_types
class _editorState extends State<Editor> {
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
  void _mdText(String) {
    setState(() {
      contents = myController.text;      
    });

  }
late final MarkdownCheckboxBuilder? checkboxBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration( 
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white)
              ),
              padding: const EdgeInsets.all(15),
              child: Markdown(
                data: contents,
              ),
            )
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white)
              ),
              padding: const EdgeInsets.all(15),
              child: MarkdownAutoPreview(
                controller: myController,
                emojiConvert: true,
                onChanged: _mdText,
                enableToolBar: true,
                autoCloseAfterSelectEmoji: false,
                showEmojiSelection: true,
              ),
            ),
          ),
        ]
      ),
    );
  }
}
