import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:markdown/markdown.dart' as md;
import 'package:markdown_editor_plus/markdown_editor_plus.dart';


class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _editorState();

}
// ignore: camel_case_types
class _editorState extends State<Editor> {
  TextEditingController myController = TextEditingController();

  String contents = "";
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void textInput(String) {
    setState(() {
      contents = myController.text;
    });
  }


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
              padding: EdgeInsets.all(15),
              child: MarkdownParse(
                data: myController.text,
              ),
            )
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white)
              ),
              padding: EdgeInsets.all(15),
              child: MarkdownAutoPreview(
                controller: myController,
                emojiConvert: true,
                onChanged: textInput,
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