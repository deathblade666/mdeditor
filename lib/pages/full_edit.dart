import 'dart:core';
import 'package:flutter/material.dart';
import 'package:mdeditor/pages/menu.dart';
import 'package:mdeditor/pages/textfield.dart';

//TODO: Make this work, toggleable view menu item

class fullEditor extends StatefulWidget {
  const fullEditor({super.key});

  @override
  State<fullEditor> createState() => fullEditorState();
}

// ignore: camel_case_types
class fullEditorState extends State<fullEditor> {
  String contents = '';

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  void mdText(String value) {
    setState(() {
     contents = value;      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        toolbarHeight: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: mdtextfield(ontextchanged: mdText,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: const Menu()
              ),
              
            ]
          ),
        ]
      ),
    );
  }
}
