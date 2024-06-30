import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Renderer extends StatelessWidget {
  const Renderer(this.value,{super.key});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration( 
        borderRadius: BorderRadius.circular(25),
        //border: Border.all(color: Colors.white)
        ),
      padding: const EdgeInsets.all(15),
      child: Markdown(
        data: value,
        styleSheet: MarkdownStyleSheet(checkbox: Theme.of(context).textTheme.bodyMedium),
        //checkboxBuilder: (value) => Checkbox(value: value, onChanged: (){}),
      ),
    );
  }
}