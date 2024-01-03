import 'package:flutter/material.dart';
import 'package:flutter_rive/navigation/custom_tab_bar.dart';
import 'package:flutter_rive/pages/custom_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> {
  Widget _tabBody = Container();

  final List<Widget> _screens = [
    CustomPage(pageName: "Chat"),
    CustomPage(pageName: "Bell"),
    CustomPage(pageName: "Search"),
    CustomPage(pageName: "User"),
  ];

  @override
  void initState() {
    _tabBody = _screens.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _tabBody,
      bottomNavigationBar: CustomTabBar(
        onTabChange: (tabIndex) {
          setState(() {
            _tabBody = _screens[tabIndex];
          });
        },
      ),
    );
  }
}
