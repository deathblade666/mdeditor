import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:markdown_toolbar/markdown_toolbar.dart';
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
  bool toolBarToggle = enableToolBar;
  var importedFilePath = '';
  var importedFileName = '';
  var importedText = '';
  static const platform = MethodChannel("Markdown_Editor_Channel");

@override
  void initState() {
    onStart();
    getOpenFileUrl();
    super.initState();
  }

  void onStart() async {
    prefs.reload();
    bool? fullEdit = prefs.getBool("ViewMode");
    bool? WordCount = prefs.getBool('enableCount');
    String? priorInput = prefs.getString('InputText');
    bool? syncScrolling = prefs.getBool('RetainsyncSwitch');
    bool? enableToolBar = prefs.getBool('enableToolbar');
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
    if (enableToolBar != null) {
      toggleToolBar(enableToolBar);
    }
  }

  void getOpenFileUrl() async {
    await platform.invokeMethod("getOpenFileUrl").then((fileUrl) async {
      try {
        importedFilePath = fileUrl as String;
        String decodeUri = Uri.decodeFull(importedFilePath);
        Uri fileUri = Uri.parse(decodeUri);
        importedFilePath = fileUri.toFilePath().replaceFirst('/file://', '');
        File file = File(importedFilePath);
        importedText = await file.readAsString();
        openFile.text = importedText;
        setState(() {});
      } catch (e) {
        if (fileUrl == null) {
          return;
        }
      }
    });
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

  void toggleToolBar(enableToolBar){
    setState(() {
      toolBarToggle = enableToolBar;
    });

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
            Visibility(
              visible: toolBarToggle,
              child: MarkdownToolbar(
                useIncludedTextField: false, 
                controller: openFile,
                iconColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                flipCollapseButtonIcon: true,
                width: 40,
                collapsable: false,
                hideNumberedList: true,
                hideStrikethrough: true,
                hideHorizontalRule: true,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 5)),
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
                      onsyncScrollEnable: syncScroll,
                      onEnableToolBar: toggleToolBar,),
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


