import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

// ignore: must_be_immutable
class mdtextfield extends StatefulWidget {
  mdtextfield(this.OpenFile,this.fileContent,{required this.ontextchanged, super.key});
  final void Function(String contents) ontextchanged;
  TextEditingController OpenFile;
  String fileContent;

  @override
  State<mdtextfield> createState() => mdtextfieldState(OpenFile,fileContent);
}

// ignore: camel_case_types
class mdtextfieldState extends State<mdtextfield> {
  mdtextfieldState(this.OpenFile, this.fileContent);
  String fileContent;
  TextEditingController OpenFile = TextEditingController();

  
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void mdText(String inputText) {
    final lines = inputText.split('\n');
    final emptyCheckbox = lines.where((e) => e == '- [ ] ');
    if (emptyCheckbox.isEmpty) {
      widget.ontextchanged(inputText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            //color: Theme.of(context).colorScheme.tertiaryFixed,
            color: Theme.of(context).colorScheme.primary,
            style: BorderStyle.solid,
            width: 1.5,
          )
      ),
      padding: const EdgeInsets.all(7),
      child: MarkdownField(
        onChanged: mdText,
        expands: true,
        emojiConvert: true,
        maxLines: null,
        controller: OpenFile,
        cursorColor: Theme.of(context).colorScheme.primary,

      ),
    );
  }
}
