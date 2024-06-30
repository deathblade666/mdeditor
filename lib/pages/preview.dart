//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:markdown/markdown.dart' as md;
//import 'package:markdown_editor_plus/markdown_editor_plus.dart';
//import 'package:markdown_editor_plus/widgets/markdown_parse_body.dart';
//import 'package:mdeditor/pages/editor.dart';



class Renderer extends StatelessWidget {
  const Renderer({super.key});


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
          child: const Markdown(
            data: "test",
          ),
        ),
      ),
    );
  }
}