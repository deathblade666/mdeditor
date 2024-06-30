import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

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
        onChanged: mdText,
        expands: true,
        emojiConvert: true,
      ),
    );
  }
}
