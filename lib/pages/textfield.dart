import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class mdtextfield extends StatefulWidget {
  mdtextfield(this.myController,this.fileContent,{required this.ontextchanged, super.key});
  final void Function(String contents) ontextchanged;
  TextEditingController myController = TextEditingController();
  String fileContent;

  @override
  State<mdtextfield> createState() => mdtextfieldState(myController,fileContent);
}

// ignore: camel_case_types
class mdtextfieldState extends State<mdtextfield> {
  mdtextfieldState(this.myController, this.fileContent);
  String fileContent;
  TextEditingController myController = TextEditingController();
  
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
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).indicatorColor,
            style: BorderStyle.solid,
            width: 1.5,
          )
      ),
      padding: const EdgeInsets.all(15),
      child: MarkdownField(
        onChanged: mdText,
        expands: true,
        emojiConvert: true,
        maxLines: null,
        controller: myController,
      ),
    );
  }
}
