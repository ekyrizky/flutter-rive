import 'package:flutter/material.dart';

class CustomPage extends StatelessWidget {
  const CustomPage({super.key, required this.pageName});

  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.amber,
      child: Text(
        pageName,
        style: TextStyle(fontSize: 32),
      ),
    );
  }
}
