import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';


// ignore: must_be_immutable
class mdtextfield extends StatefulWidget {
  mdtextfield(
    this.openFile,
    this.fileContent,
    this.userInputController,
    {
      required this.ontextchanged, 
      super.key
    }
  );
  final void Function(String contents) ontextchanged;
  TextEditingController openFile;
  String fileContent;
  ScrollController userInputController;

  @override
  State<mdtextfield> createState() => mdtextfieldState();
  
}

// ignore: camel_case_types
class mdtextfieldState extends State<mdtextfield> {
  //String fileContent;

  listener (){
    double offset = widget.userInputController.offset;
    print("Text Offset: $offset");
  }

  @override
  void initState() {
    widget.userInputController.addListener(listener);
    //widget.openFile.addListener(textListener);
    super.initState();
  }

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void mdText(String inputText) {
    widget.ontextchanged(inputText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            style: BorderStyle.solid,
            width: 1.5,
          )
      ),
      child: MarkdownField(
        onChanged: mdText,
        expands: true,
        emojiConvert: true,
        maxLines: null,
        controller: widget.openFile,
        cursorColor: Theme.of(context).colorScheme.primary,
        scrollController: widget.userInputController,
        padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
