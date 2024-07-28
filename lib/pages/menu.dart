import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
// function for theme control

  String filePath = '';
  String _filename = '';
  bool fullEdit = true;
  bool WordCount = false;
  const List<String> list = <String>['system', 'dark', 'light', 'black'];
  String dropDownValue = list.first;


class Menu extends StatefulWidget {
  Menu(this.inputText,this.OpenFile,this.wordCount,{required this.onEnableWordCount, required this.onModeToggle, required this.onFileLoad,required this.onfileName,required this.onThemeSelected,super.key});
  final void Function(String fileContent) onFileLoad;
  final void Function(String fileName) onfileName;
  final void Function(bool fullEdit) onModeToggle;
  final void Function(bool WordCount) onEnableWordCount;
  void Function(String? selectedTheme) onThemeSelected;
  TextEditingController OpenFile = TextEditingController();
  final String inputText;
  int wordCount;


  @override
  State<Menu> createState() => MenuState(inputText, OpenFile, wordCount);
}
  class MenuState extends State<Menu> {
    //Declarations
    MenuState(this.inputText, this.OpenFile, this.wordCount);
    final String inputText;
    int wordCount;
    TextEditingController OpenFile = TextEditingController();
    bool switchModeValue = false;
    bool switchWCValue = false;
    
  
  void closeApp({bool? animated}) async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', animated);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("InputText", inputText);
  }

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

  void enableFullEdit() async {
    fullEdit=!fullEdit;
    widget.onModeToggle(fullEdit);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("ViewMode", fullEdit);
  }

  void showWordCount() async {
    final prefs = await SharedPreferences.getInstance();
    WordCount = !WordCount;
    widget.onEnableWordCount(WordCount);
    prefs.setBool("DisplayWordCount", WordCount);
  }

  void setTheme(String? value) async {
    var selectedTheme = value;
    widget.onThemeSelected(selectedTheme);
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
        PopupMenuItem(
          child: const Text("Options"),
          onTap: () { showDialog(
            context: context, 
            builder: (context) => optionsDialog(switchModeValue,switchWCValue,widget.onEnableWordCount,widget.onModeToggle, onThemeSelected: setTheme,)
            
          );}
        ),
        PopupMenuItem<menuItems>(
          value: menuItems.close,
          onTap: closeApp,
          child: const Text("Close"),
        ),
      ]
    );
  }
}

class optionsDialog extends StatefulWidget {
  final Function onEnableWordCount;
  final Function onModeToggle;
  bool switchModeValue;
  bool switchWCValue;

  optionsDialog(this.switchModeValue, this.switchWCValue, this.onEnableWordCount, this.onModeToggle, {required this.onThemeSelected,super.key});
  void Function (String? selectedTheme) onThemeSelected;
  @override
  optionsDialogState createState() => optionsDialogState();
}



class optionsDialogState extends State<optionsDialog> {

  void enableFullEdit() async {
    fullEdit = !fullEdit;
    widget.onModeToggle(fullEdit);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("ViewMode", fullEdit);
  }

  void showWordCount() async {
    final prefs = await SharedPreferences.getInstance();
    WordCount = !WordCount;
    widget.onEnableWordCount(WordCount);
    prefs.setBool("DisplayWordCount", WordCount);
  }
  
  @override 
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      alignment: Alignment.center,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(padding: EdgeInsets.all(20)),
          PopupMenuItem<menuItems>(
            value: menuItems.switchTheme,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Theme"),
                DropdownMenu(
                  width: 125,
                  initialSelection: list.first,
                  onSelected: (String? value) async {
                    setState(() {
                      var selectedTheme = value;
                      widget.onThemeSelected(selectedTheme);
                    });
                  },
                  dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
              ]
            )
          ), 
          PopupMenuItem(
            child: SwitchListTile(
              title: const Text("Full Edit Mode"),
              activeColor: Theme.of(context).colorScheme.primary,
              value: widget.switchModeValue,
              onChanged: (bool value) {
                setState(() {
                  widget.switchModeValue = value;
                });
                enableFullEdit();
              }
            ),
          ),
          PopupMenuItem<menuItems>(
            child: SwitchListTile(
              value: widget.switchWCValue, 
              title: const Text("Display Word Count"),
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool value) async {
                setState(() {
                  widget.switchWCValue = value;
                });
                showWordCount();
              }
            )
          ),
          OutlinedButton(
            onPressed: (){Navigator.pop(context);},
            child: const Text("Save"),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
        ],
      ),
    );
  }
}