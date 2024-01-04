import 'package:flutter/material.dart';
import 'package:flutter_rive/navigation/custom_tab_bar.dart';
import 'package:flutter_rive/navigation/side_menu.dart';
import 'package:flutter_rive/pages/custom_page.dart';
import 'package:rive/rive.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> {
  Widget _tabBody = Container();
  late SMIBool _menu;

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

  void _onMenuInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine");
    artboard.addController(controller!);
    _menu = controller.findInput<bool>("isOpen") as SMIBool;
    _menu.value = true;
  }

  void onMenuPress() {
    _menu.change(!_menu.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(children: [
        SideMenu(),
        _tabBody,
        SafeArea(
          child: GestureDetector(
            onTap: onMenuPress,
            child: Container(
              margin: EdgeInsets.only(top: 8, left: 16),
              width: 44,
              height: 44,
              child: RiveAnimation.asset(
                'assets/rive/menu_button.riv',
                stateMachines: ["State Machine"],
                animations: ["open", "close"],
                onInit: _onMenuInit,
              ),
            ),
          ),
        ),
      ]),
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
