import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;


//TODO: Change font size (bigger)

class Renderer extends StatelessWidget {
  Renderer(this.OpenFile,this.value,{super.key});
  String value;
  TextEditingController OpenFile = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        ),
      padding: const EdgeInsets.all(15),
      child: Markdown(
        data: value,
        styleSheet: MarkdownStyleSheet(checkbox: Theme.of(context).textTheme.bodyMedium),
        selectable: true,
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          <md.InlineSyntax>[
            md.EmojiSyntax(),
            ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
          ],
        ),
        softLineBreak: true,
        shrinkWrap: true,
        //checkboxBuilder: (value) => Checkbox(value: value, onChanged: (){}),
      ),
    );
  }
}