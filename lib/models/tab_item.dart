import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class TabItem {
  TabItem({
    this.stateMachine = "",
    this.artboart = "",
    this.status,
  });

  UniqueKey? id = UniqueKey();
  String stateMachine;
  String artboart;
  late SMIBool? status;

  static List<TabItem> tabItems = [
    TabItem(stateMachine: "CHAT_Interactivity", artboart: "CHAT"),
    TabItem(stateMachine: "BELL_Interactivity", artboart: "BELL"),
    TabItem(stateMachine: "SEARCH_Interactivity", artboart: "SEARCH"),
    TabItem(stateMachine: "USER_Interactivity", artboart: "USER"),
  ];
}
