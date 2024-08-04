import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/widgets/markdown_parse.dart';


//TODO: Change font size (bigger)

// ignore: must_be_immutable
class Renderer extends StatelessWidget {
  Renderer(this.OpenFile,this.value,{super.key});
  String value;
  TextEditingController OpenFile = TextEditingController();
  ScrollController autoScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        ),
      padding: const EdgeInsets.all(15),
      child: MarkdownParse(
        data: value,
        controller: autoScroll,
      ),
    );
  }
}