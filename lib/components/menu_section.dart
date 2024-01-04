import 'package:flutter/material.dart';
import 'package:flutter_rive/components/menu_row.dart';
import 'package:flutter_rive/models/menu_item.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key, required this.title, required this.menuItems});

  final String title;
  final List<MenuItem> menuItems;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Column(children: [
            for (var menu in menuItems) ...[
              Divider(
                color: Colors.white.withOpacity(0.2),
                thickness: 1,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              MenuRow(menuItem: menu)
            ]
          ]),
        )
      ],
    );
  }
}
