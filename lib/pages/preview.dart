import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editor_plus/widgets/markdown_parse.dart';
import 'package:markdown/markdown.dart' as md;


//TODO: Change font size (bigger)

// ignore: must_be_immutable
class Renderer extends StatefulWidget {
  Renderer(this.openFile,this.value,this.scrollRenderController,{super.key});
  String value;
  TextEditingController openFile = TextEditingController();
  ScrollController scrollRenderController = ScrollController();

  @override
  State<Renderer> createState() => _RendererState();
}

class _RendererState extends State<Renderer> {

  listener (){
    double offset = widget.scrollRenderController.offset;
    print("Render Offset: $offset");
  }
  
  @override
  void initState() {
    widget.scrollRenderController.addListener(listener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        ),
      padding: const EdgeInsets.all(15),
      child: MarkdownParse(
        data: widget.value,
        controller: widget.scrollRenderController,
        selectable: true,
        inlineSyntaxes: [CheckboxSyntax()],
      ),
    );
  }
}

class CheckboxSyntax extends md.InlineSyntax {
  CheckboxSyntax() : super(r'- \[ \] ');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Element.text('checkbox', ''));
    return true;
  }
}
