import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

 enum menuItems {
  save, 
  open,
  fileInfo,
  close,
  switchTheme,
  switchView,
  enableWorkCount,
  }

//TODO: Implement new functions
// function and widget for file info
// function for theme control
// function to change view modes
// function to enable persistent word counter

  String filePath = '';
  String _filename = '';
  bool fullEdit = true;
  bool WordCount = false;

  void closeApp({bool? animated}) async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', animated);
  }

class Menu extends StatefulWidget {
  Menu(this.value,this.OpenFile,this.wordCount,{required this.onEnableWordCount, required this.onModeToggle, required this.onFileLoad,required this.onfileName,super.key});
  final void Function(String fileContent) onFileLoad;
  final void Function(String fileName) onfileName;
  final void Function(bool fullEdit) onModeToggle;
  final void Function(bool WordCount) onEnableWordCount;
  TextEditingController OpenFile = TextEditingController();
  final String value;
  int wordCount;


  @override
  State<Menu> createState() => MenuState(value, OpenFile, wordCount);
}
  class MenuState extends State<Menu> {
    MenuState(this.value, this.OpenFile, this.wordCount);
    final String value;
    int wordCount;
    TextEditingController OpenFile = TextEditingController();
  
  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final filePicked = result.files;
    final path = filePicked.first.path.toString();
    final file = File(path);
    final fileName = result.names.join(',').toString();
    _filename = fileName;
    filePath = path;
    final fileContent = await file.readAsString();
    widget.onFileLoad(fileContent);
    widget.onfileName(fileName);
  }

  void switchViewMode() async {
    fullEdit=!fullEdit;
    widget.onModeToggle(fullEdit);
  }

  void showWordCount() async {
    WordCount = !WordCount;
    widget.onEnableWordCount(WordCount);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 0,
      color: Theme.of(context).colorScheme.onPrimary,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<menuItems>>[
        PopupMenuItem<menuItems>(
          value: menuItems.save,
          onTap: () async {
            List<int> list = utf8.encode(OpenFile.text);
            Uint8List bytes = Uint8List.fromList(list);
            final outputfile = await FilePicker.platform.saveFile(bytes: bytes);
            final file = File(outputfile!);
            file.writeAsString(OpenFile.text);
            showDialog(
              context: context, 
              builder: (BuildContext context){
                return AlertDialog(
                title: const Text("Success"),
                content: Text("Save successfully to $outputfile"),
                );
              }
            );
          },   
          child: const Text("Save"),
        ),
        PopupMenuItem<menuItems>(
          value: menuItems.open,
          onTap: pickFile,
          child: const Text("Open"),
        ),
        PopupMenuItem<menuItems>(
          value: menuItems.fileInfo,
          onTap: () { showDialog(
            context: context, builder: (BuildContext context){
              return Dialog(
              elevation: 1,
              alignment: Alignment.center,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                height: 200,
                width: 200,
                child: Text("Word Count: $wordCount"),
              ),);
            }
          );},
          child: const Text("File Info"),
        ),
        const PopupMenuItem<menuItems>(
          value: menuItems.close,
          onTap: closeApp,
          child: Text("Close"),
        ),
        PopupMenuItem(
          child: const Text("Options"),
          onTap: () { showDialog(
            context: context, builder: (BuildContext context){
              return Dialog(
                elevation: 1,
                alignment: Alignment.center,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  height: 200,
                  width: 200,
                  child: Column(
                    children: [
                      PopupMenuItem<menuItems>(
                        value: menuItems.switchView,
                        onTap: switchViewMode,
                        child: const Text("Switch Mode"),
                      ),
                      const PopupMenuItem<menuItems>(
                        value: menuItems.switchTheme,
                        //onSelect: switchTheme,
                        child: Text("Change Theme"),
                      ), 
                      PopupMenuItem<menuItems>(
                      onTap: showWordCount,
                      child: const Text("Word Count")
                      ),
                    ],
                  ),
                )
              );
            }
          );}
        ),
      ]
    );
  }
}