import 'package:flutter/material.dart';
import 'package:flutter_rive/models/tab_item.dart';

class MenuItem {
  MenuItem({this.id, this.title = "", required this.riveIcon});

  UniqueKey? id = UniqueKey();
  String title;
  TabItem riveIcon;

  static List<MenuItem> menuItems = [
    MenuItem(
      title: "Home",
      riveIcon: TabItem(stateMachine: "HOME_Interactivity", artboart: "HOME"),
    ),
    MenuItem(
      title: "Chat",
      riveIcon: TabItem(stateMachine: "CHAT_Interactivity", artboart: "CHAT"),
    ),
    MenuItem(
      title: "Search",
      riveIcon:
          TabItem(stateMachine: "SEARCH_Interactivity", artboart: "SEARCH"),
    ),
    MenuItem(
      title: "User",
      riveIcon: TabItem(stateMachine: "USER_Interactivity", artboart: "USER"),
    ),
  ];

  static List<MenuItem> menuItems2 = [
    MenuItem(
      title: "Sound",
      riveIcon: TabItem(stateMachine: "AUDIO_Interactivity", artboart: "AUDIO"),
    ),
    MenuItem(
      title: "Setting",
      riveIcon:
          TabItem(stateMachine: "SETTINGS_Interactivity", artboart: "SETTINGS"),
    ),
  ];
}
