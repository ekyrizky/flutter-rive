import 'package:flutter/material.dart';
import 'package:flutter_rive/components/menu_section.dart';
import 'package:flutter_rive/models/menu_item.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final List<MenuItem> _menuIcons = MenuItem.menuItems;
  final List<MenuItem> _menuIcons2 = MenuItem.menuItems2;
  String _selectedMenu = MenuItem.menuItems[0].title;

  void onMenuPress(MenuItem menu) {
    setState(() {
      _selectedMenu = menu.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(45),
      ),
      constraints: BoxConstraints(maxWidth: 280),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  foregroundColor: Colors.white,
                  radius: 24,
                  child: Icon(
                    Icons.person,
                    size: 32,
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rizky Ananda",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Software Engineer",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          MenuSection(
            title: "MENU",
            menuItems: _menuIcons,
            selectedMenu: _selectedMenu,
            onMenuPress: onMenuPress,
          ),
          MenuSection(
            title: "SETTINGS",
            menuItems: _menuIcons2,
            selectedMenu: _selectedMenu,
            onMenuPress: onMenuPress,
          )
        ],
      ),
    );
  }
}
