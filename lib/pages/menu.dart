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

  String filePath = '';
  String _filename = '';
  bool fullEdit = true;
  bool WordCount = false;
  bool syncScrolling = false;
  bool enableToolBar = false;
  const List<String> list = <String>['system', 'dark', 'light',];
  String dropDownValue = list.first;


// ignore: must_be_immutable
class Menu extends StatefulWidget {
  Menu(
    this.prefs,
    this.inputText,
    this.openFile,
    this.wordCount,
    {required this.onEnableWordCount, 
      required this.onModeToggle, 
      required this.onFileLoad,
      required this.onfileName,
      required this.onThemeSelected,
      required this.onsyncScrollEnable,
      required this.onEnableToolBar,
      super.key
      }
    );
  final void Function(String fileContent) onFileLoad;
  final void Function(String fileName) onfileName;
  final void Function(bool fullEdit) onModeToggle;
  final void Function(bool WordCount) onEnableWordCount;
  void Function(String? selectedTheme) onThemeSelected;
  final void Function(bool syncScrolling) onsyncScrollEnable;
  final void Function(bool enableToolBar) onEnableToolBar;
  TextEditingController openFile = TextEditingController();
  final String inputText;
  int wordCount;
  SharedPreferences prefs;


  @override
  State<Menu> createState() => MenuState(inputText, openFile, wordCount, prefs);
}
  class MenuState extends State<Menu> {
    //Declarations
    MenuState(this.inputText, this.openFile, this.wordCount,this.prefs);
    final String inputText;
    int wordCount=0;
    TextEditingController openFile = TextEditingController();
    bool switchModeValue = false;
    bool switchWCValue = false;
    SharedPreferences prefs;
    bool switchInputvalue = false;
    bool switchSyncScroll = false;
    bool enableToolBar = false;
  
  void closeApp({bool? animated}) async {
    prefs.reload();
    bool? RetainInputSwitch = prefs.getBool('RetainInputSwitch');
    if (RetainInputSwitch == true){
      prefs.setString("InputText", openFile.text);
    }
    if (RetainInputSwitch == false){
      await prefs.remove('InputText');
    }
    SystemNavigator.pop(animated: true);
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

  void setTheme(String value) async {
    var selectedTheme = value;
    widget.onThemeSelected(selectedTheme);
    prefs.setString("selectedTheme", selectedTheme);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController newfile = TextEditingController();
    return PopupMenuButton(
      elevation: 0,
      color: Theme.of(context).colorScheme.onPrimary,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<menuItems>>[
        PopupMenuItem<menuItems>(
          value: menuItems.save,
          onTap: () async {          
            Uint8List bytes = utf8.encode(openFile.text);
            //var file = File('/sdcard/mdeditor/test files/test58.md');
            try {
              final result = await FilePicker.platform.saveFile(bytes: bytes);
              print("RESULT: $result");
            } catch(result) {
              if (result != null || result != "") {
                //var file = File("$result");
               // var sink = file.openWrite();
               // sink.add(bytes);
                showDialog(
                  context: context, 
                  builder: (BuildContext context){
                    return AlertDialog(
                    title: const Text("Success"),
                    content: Text('Save successfully to $result'),
                );
              }
            );
              } else {
                return showDialog(
                  context: context, 
                  builder: (BuildContext context){
                    return const AlertDialog(
                      title: Text("Fail"),
                      content: Text('There was an issue saving your file :('),
                    );
                  }
                );
              }
            }
          }, 
          child: const Text("Save"),
        ),
        PopupMenuItem<menuItems>(
          value: menuItems.open,
          onTap: pickFile,
          child: const Text("Open"),
        ),
        PopupMenuItem(
          child: const Text("Options"),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => optionsDialog(
                switchSyncScroll,
                switchModeValue,
                switchWCValue,
                widget.onEnableWordCount,
                widget.onModeToggle, 
                onThemeSelected: setTheme,
                widget.onsyncScrollEnable,
                prefs,
                switchInputvalue,
                enableToolBar,
                widget.onEnableToolBar,
              )
            );
          }
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

// ignore: must_be_immutable
class optionsDialog extends StatefulWidget {
  final Function onEnableWordCount;
  final Function onModeToggle;
  final Function onsyncScrollEnable;
  final Function onEnableToolBar;
  bool switchModeValue;
  bool switchWCValue;
  bool switchInputvalue;
  bool switchSyncScroll;
  bool enableToolBar;

  optionsDialog(
    this.switchSyncScroll,
    this.switchModeValue, 
    this.switchWCValue, 
    this.onEnableWordCount, 
    this.onModeToggle,
    this.onsyncScrollEnable,
    this.prefs,
    this.switchInputvalue,
    this.enableToolBar,
    this.onEnableToolBar,
    {
      required this.onThemeSelected,
      super.key
    }
  );
  void Function (String selectedTheme) onThemeSelected;
  SharedPreferences prefs;
  @override
  optionsDialogState createState() => optionsDialogState(prefs);
}

class optionsDialogState extends State<optionsDialog> {
  optionsDialogState(this.prefs);
  SharedPreferences prefs;

  void enableFullEdit(value) {
    prefs.reload();
    bool? viewModeSwitch = prefs.getBool('ViewModeSwitch');
    if (viewModeSwitch == true){
      fullEdit = false;
    }
    if (viewModeSwitch == false){
      fullEdit = true;
    }
    widget.onModeToggle(fullEdit);
    prefs.setBool("ViewMode", fullEdit);
  }

  void enableToolbar(value) {
    prefs.reload();
    bool? toolbar = prefs.getBool('enableToolbar');
    if (toolbar == true){
      enableToolBar = true;
    }
    if (toolbar == false) {
      enableToolBar = false;
    }
    widget.onEnableToolBar(enableToolBar);
    prefs.setBool('enableToolbar', enableToolBar);
  }

  void showWordCount(value) {
    prefs.reload();
    bool? enableCount = prefs.getBool('DisplayWordCount');
    if (enableCount == false){
      WordCount = false;
    }
    if (enableCount == true){
      WordCount = true;
    }
    widget.onEnableWordCount(WordCount);
    prefs.setBool("enableCount", WordCount);
  }
  
  void synchronizeScrolling(value) {
    prefs.reload();
    bool? syncScroll = prefs.getBool('RetainsyncSwitch');
    if (syncScroll == false) {
      syncScrolling = false;
    }
    if (syncScroll == true) {
      syncScrolling = true;
    }
    widget.onsyncScrollEnable(syncScrolling);
  }

  @override
  void initState() {
    onStart();
    super.initState();
  }

  void onStart() async {
    prefs.reload();
    bool? wordCountValue = prefs.getBool('DisplayWordCount');
    bool? viewmodeValue = prefs.getBool('ViewModeSwitch');
    bool? retainInput = prefs.getBool('RetainInputSwitch');
    String? selectedTheme = prefs.getString('selectedTheme');
    bool? syncScroll = prefs.getBool('RetainsyncSwitch');
    bool? toolbar = prefs.getBool('enableToolbar');
    setState(() {
    if (viewmodeValue != null) {
      widget.switchModeValue = viewmodeValue;
    }
    if (wordCountValue != null) {
      widget.switchWCValue = wordCountValue;
    }
    if (retainInput != null){
      widget.switchInputvalue = retainInput;
    }
    if (selectedTheme == null) {
      prefs.setString('selectedTheme', "system");
    }
    if (syncScroll != null){
      widget.switchSyncScroll = syncScroll;
    }
    if (toolbar != null) {
      widget.enableToolBar = toolbar;
    }
    });
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
                  textStyle: const TextStyle(fontSize: 14,),                  
                  initialSelection: widget.prefs.getString('selectedTheme'),
                  onSelected: (String? value) async {
                    setState(() {
                      Navigator.pop(context);
                      var selectedTheme = value.toString();
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
              subtitle: const Text("Toggles full screen editing"),
              activeColor: Theme.of(context).colorScheme.primary,
              value: widget.switchModeValue,
              onChanged: (bool value) async {
                setState(() {
                  widget.switchModeValue = value;
                  prefs.setBool("ViewModeSwitch", value);
                });
                enableFullEdit(value);
              }
            ),
          ),
          PopupMenuItem<menuItems>(
            child: SwitchListTile(
              value: widget.switchWCValue, 
              title: const Text("Display Word Count"),
              subtitle: const Text("Toggles a word counter"),
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool value) async {
                setState(() {
                  widget.switchWCValue = value;
                  prefs.setBool("DisplayWordCount", value);
                });
                showWordCount(value);
              }
            )
          ),
          PopupMenuItem(
            child: SwitchListTile(
              title: const Text("Retain Input"),
              subtitle: const Text("Retains text between sessions"),
              activeColor: Theme.of(context).colorScheme.primary,
              value: widget.switchInputvalue,
              onChanged: (bool value) async {
                setState(() {
                  widget.switchInputvalue = value;
                  prefs.setBool("RetainInputSwitch", value);
                });
              },
            )
          ),
          PopupMenuItem(
            child: SwitchListTile(
              value: widget.enableToolBar, 
              title: const Text("Enable Markdown Toolbar"),
              subtitle: const Text("Enables a markdown Toolbar"),
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool value) async {
                setState(() {
                  widget.enableToolBar = value;
                  prefs.setBool("enableToolbar", value);
                });
                enableToolbar(value);
              }
            )
          ),
          PopupMenuItem(
            child: SwitchListTile(
              title: const Text("Synchronized Scrolling"),
              subtitle: const Text("Synchronize scrolling across the whole screen"),
              activeColor: Theme.of(context).colorScheme.primary,
              value: widget.switchSyncScroll, 
              onChanged: (bool value) async {
                setState(() {
                  widget.switchSyncScroll = value;
                  prefs.setBool("RetainsyncSwitch", value);
                });
                synchronizeScrolling(value);
              },
            )
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () async {
                prefs.clear();
                Navigator.pop(context);
              }, 
              child: const Text("Clear Cache"),
              ),
              const Padding(padding: EdgeInsets.only(right: 15)),
              OutlinedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  onStart();
                },
              child: const Text("Save"),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}