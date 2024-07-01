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
// Save function
// Open function
// function and widget for file info
// function for theme control
// function to change view modes
// function to enable persistent word counter

  void closeApp({bool? animated}) async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', animated);
  }

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: const EdgeInsets.only(left: 5),
      elevation: 0,
      color: Colors.grey[400],
      itemBuilder: (BuildContext context) => <PopupMenuEntry<menuItems>>[
        const PopupMenuItem<menuItems>(
          value: menuItems.save,
          //onSelect: save,
          child: Text("Save"),
        ),
        const PopupMenuItem<menuItems>(
          value: menuItems.open,
          //onSelect: openFile,
          child: Text("Open"),
        ),
        const PopupMenuItem<menuItems>(
          value: menuItems.fileInfo,
          //onSelect: showFileInfo,
          child: Text("File Info"),
        ),
        const PopupMenuItem<menuItems>(
          value: menuItems.close,
          onTap: closeApp,
          child: Text("Close"),
        ),
        const PopupMenuItem<menuItems>(
          value: menuItems.switchView,
          //onSelect: switchViewMode,
          child: Text("Switch Mode"),
        ),
        const PopupMenuItem<menuItems>(
          value: menuItems.switchTheme,
          //onSelect: switchTheme,
          child: Text("Change Theme"),
        ),   
      ]
    );
  }
}