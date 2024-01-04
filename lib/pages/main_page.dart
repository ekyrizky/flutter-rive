import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_rive/navigation/custom_tab_bar.dart';
import 'package:flutter_rive/navigation/side_menu.dart';
import 'package:flutter_rive/pages/custom_page.dart';
import 'package:rive/rive.dart';
import 'dart:math' as math;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> with TickerProviderStateMixin {
  Widget _tabBody = Container();
  late SMIBool _menu;
  late AnimationController? _animationController;
  late Animation<double> _sidebarAnim;
  final springDesc = const SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  final List<Widget> _screens = [
    CustomPage(pageName: "Chat"),
    CustomPage(pageName: "Bell"),
    CustomPage(pageName: "Search"),
    CustomPage(pageName: "User"),
  ];

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );
    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    ));
    _tabBody = _screens.first;
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _onMenuInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine");
    artboard.addController(controller!);
    _menu = controller.findInput<bool>("isOpen") as SMIBool;
    _menu.value = true;
  }

  void onMenuPress() {
    if (_menu.value) {
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _animationController?.animateWith(springAnim);
    } else {
      _animationController?.reverse();
    }
    _menu.change(!_menu.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned(
              child: Container(
            color: Colors.blue,
          )),
          AnimatedBuilder(
            animation: _sidebarAnim,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(((1 - _sidebarAnim.value) * -30) * math.pi / 180)
                  ..translate((1 - _sidebarAnim.value) * -300),
                child: child,
              );
            },
            child: FadeTransition(
              opacity: _sidebarAnim,
              child: SideMenu(),
            ),
          ),
          AnimatedBuilder(
            animation: _sidebarAnim,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 - _sidebarAnim.value * 0.1,
                child: Transform.translate(
                  offset: Offset(_sidebarAnim.value * 265, 0),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY((_sidebarAnim.value * 30) * math.pi / 180),
                    child: child!,
                  ),
                ),
              );
            },
            child: _tabBody,
          ),
          AnimatedBuilder(
            animation: _sidebarAnim,
            builder: (context, child) {
              return SafeArea(
                child: Row(
                  children: [
                    SizedBox(width: _sidebarAnim.value * 216),
                    child!,
                  ],
                ),
              );
            },
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
          )
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _sidebarAnim,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _sidebarAnim.value * 300),
            child: child,
          );
        },
        child: CustomTabBar(
          onTabChange: (tabIndex) {
            setState(() {
              _tabBody = _screens[tabIndex];
            });
          },
        ),
      ),
    );
  }
}
