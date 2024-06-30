//import 'dart:core';
//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:markdown/markdown.dart' as md;
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
//import 'package:markdown_editor_plus/widgets/markdown_parse_body.dart';
//import 'package:mdeditor/pages/preview.dart';

class mdtextfield extends StatefulWidget {
  const mdtextfield( {required this.ontextchanged, super.key});
  final void Function(String contents) ontextchanged;
  @override
  State<mdtextfield> createState() => mdtextfieldState();

}

// ignore: camel_case_types
class mdtextfieldState extends State<mdtextfield> {


  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void mdText(String value) {
    final lines = value.split('\n');
    final emptyCheckbox = lines.where((e) => e == '- [ ] ');
    if (emptyCheckbox.isEmpty) {
      widget.ontextchanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white)
      ),
      padding: const EdgeInsets.all(15),
      child: MarkdownField(
       // controller: myController,
        //emojiConvert: true,
        onChanged: mdText,
        expands: true,
        //enableToolBar: true,
        //autoCloseAfterSelectEmoji: false,
        //showEmojiSelection: true,
      ),
    );
  }
}
