import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_rive/navigation/custom_tab_bar.dart';
import 'package:flutter_rive/navigation/side_menu.dart';
import 'package:flutter_rive/pages/custom_page.dart';
import 'package:flutter_rive/pages/profile_page.dart';
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
  late AnimationController? _profileController;
  late Animation<double> _sidebarAnim;
  late Animation<double> _profileAnim;
  bool _showProfile = false;

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
    _profileController = AnimationController(
      duration: Duration(milliseconds: 350),
      upperBound: 1,
      vsync: this,
    );
    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    ));
    _profileAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _profileController!,
      curve: Curves.linear,
    ));
    _tabBody = _screens.first;
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _profileController?.dispose();
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

  void _presentProfile(bool show) {
    if (show) {
      setState(() {
        _showProfile = true;
      });
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _profileController?.animateWith(springAnim);
    } else {
      _profileController?.reverse().whenComplete(() => {
            setState(() {
              _showProfile = false;
            })
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned(
            child: GestureDetector(
              onTap: onMenuPress,
              child: Container(color: Colors.blue),
            ),
          ),
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
              child: SideMenu(
                onMenuPressed: () {
                  onMenuPress();
                },
              ),
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
            child: GestureDetector(
              onTap: () {
                if (!_menu.value) {
                  onMenuPress();
                }
              },
              child: _tabBody,
            ),
          ),
          AnimatedBuilder(
            animation: _sidebarAnim,
            builder: (context, child) {
              return Positioned(
                  top: MediaQuery.of(context).padding.top,
                  right: (_sidebarAnim.value * -100) + 16,
                  child: child!);
            },
            child: GestureDetector(
              onTap: () {
                _presentProfile(true);
              },
              child: Container(
                width: 32,
                height: 32,
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.person_outline),
              ),
            ),
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
          ),
          if (_showProfile)
            AnimatedBuilder(
              animation: _profileAnim,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    -(MediaQuery.of(context).size.height +
                            MediaQuery.of(context).padding.bottom) *
                        (1 - _profileAnim.value),
                  ),
                  child: child!,
                );
              },
              child: SafeArea(
                top: false,
                maintainBottomViewPadding: true,
                child: Container(
                  transform: Matrix4.translationValues(
                      0, -(MediaQuery.of(context).padding.bottom + 18), 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ProfilePage(
                    closeProfile: () {
                      _presentProfile(false);
                    },
                  ),
                ),
              ),
            )
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: !_showProfile ? _sidebarAnim : _profileAnim,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              !_showProfile
                  ? _sidebarAnim.value * 300
                  : _profileAnim.value * 200,
            ),
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
