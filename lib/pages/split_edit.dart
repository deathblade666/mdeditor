import 'dart:core';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:mdeditor/pages/menu.dart';
import 'package:mdeditor/pages/preview.dart';
import 'package:mdeditor/pages/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editor extends StatefulWidget {
  Editor(this.prefs,{super.key, required this.onThemeSelect});
  final void Function(String selectedtheme) onThemeSelect;
  SharedPreferences prefs;

  @override
  State<Editor> createState() => editorState(prefs);
}

class editorState extends State<Editor> {
  editorState(this.prefs);
  SharedPreferences prefs;
  String contents = '';
  String fileContent = '';
  String NameofFile = '';
  bool _full = fullEdit;
  bool showWordCount = WordCount;
  int wordCount = 0;
  var theme = ThemeMode.system;
  TextEditingController openFile = TextEditingController();
  LinkedScrollControllerGroup scrollGroup = LinkedScrollControllerGroup();
  ScrollController scrollRenderController = ScrollController();
  ScrollController userInputController = ScrollController();

@override
  void initState() {
    onStart();
    super.initState();
  }

  void onStart() async {
    prefs.reload();
    bool? fullEdit = prefs.getBool("ViewMode");
    bool? WordCount = prefs.getBool('enableCount');
    String? priorInput = prefs.getString('InputText');
    bool? syncScrolling = prefs.getBool('RetainsyncSwitch');
    if (WordCount != null){
      enableWordCount(WordCount);
    }
    if (fullEdit != null) {
      switchViewMode(fullEdit);
    }
    if (priorInput != null ){
      fileContent=priorInput;
      loadedFile(fileContent);
    }
    if (syncScrolling != null){
      syncScroll(syncScrolling);
    }
  }

  void syncScroll (syncScrolling){
    if (syncScrolling == true) {
      setState(() {
        scrollRenderController = scrollGroup.addAndGet();
        userInputController = scrollGroup.addAndGet();
      });
    }
    if (syncScrolling == false) {
      if (userInputController.hasClients == true){
        setState(() {
          userInputController.dispose();
        });
      }
      if (scrollRenderController.hasClients == true){
        setState(() {
          scrollRenderController.dispose();
        });
      }
    }
  }

  void mdText(String inputText) {
    setState(() {
      var regExp = RegExp(r"\w+(\'\w+)?");
      contents = inputText;
      wordCount = regExp.allMatches(contents).length;
    });
  }

  void loadedFile(fileContent){
    setState(() {
      var regExp = RegExp(r"\w+(\'\w+)?");
      openFile.text = fileContent;
      contents = fileContent;
      wordCount = regExp.allMatches(contents).length;
    });
  }

  void setFileName(fileName) {
    setState(() {
      NameofFile = fileName;
    });
  }

  void switchViewMode(fullEdit) {
    setState(() {
      _full=fullEdit;
    });
  }

  void toggleSyncScrolling(){
    setState(() {
      
    });
  }

  void enableWordCount(WordCount) {
    setState(() {
      showWordCount=WordCount;
    });
  }

  void setTheme(selectedTheme){
    widget.onThemeSelect(selectedTheme);
  }
      
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          forceMaterialTransparency: true,
          toolbarHeight: 2,
        ),
        body: Column(
          children: [
            Visibility(
              visible: _full,
              child:Expanded(
                flex: 2,
                child: Renderer(openFile, contents, scrollRenderController),
              ),
            ),
            Expanded(
             child: mdtextfield(openFile, fileContent,ontextchanged: mdText, userInputController),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 15)),
                    Text(NameofFile),
                  ],
                ),
                Row(
                  children: [
                    Visibility(
                      visible: showWordCount,
                      child: Text("$wordCount"),
                    ),
                    Menu(
                      prefs,
                      onFileLoad: loadedFile, 
                      contents, 
                      openFile, 
                      onfileName: setFileName, 
                      onModeToggle: switchViewMode, 
                      wordCount, onEnableWordCount: enableWordCount,
                      onThemeSelected: setTheme,
                      onsyncScrollEnable: syncScroll,),
                    const Padding(padding: EdgeInsets.only(right: 15)),
                  ],
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }
}


