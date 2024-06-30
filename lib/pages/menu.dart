import 'package:flutter/material.dart';

 enum menuItems {
  save, 
  open,
  fileInfo,
  switchTheme,
  switchView,
  enableWorkCount
  }

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: const EdgeInsets.only(left: 5),
      elevation: 0,
      color: Theme.of(context).primaryColor,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<menuItems>>[
        const PopupMenuItem<menuItems>(
          value: menuItems.save,
          //nTap: save,
          child: Text("Save"),
        ),
        const PopupMenuItem<menuItems>(
          value: menuItems.open,
          //onTap: openFile,
          child: Text("Open"),
        ),
        const PopupMenuItem<menuItems>(
          value: menuItems.fileInfo,
          //onTap: showFileInfo,
          child: Text("File Info"),
        ),
        const PopupMenuItem<menuItems>(
          value: menuItems.switchView,
          //onTap: switchViewMode,
          child: Text("Switch Mode"),
        ),
        const PopupMenuItem<menuItems>(
          value: menuItems.switchTheme,
          //onTap: switchTheme,
          child: Text("Change Theme"),
        ),   
      ]
    );
  }
}