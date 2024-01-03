import 'package:flutter/material.dart';
import 'package:flutter_rive/models/tab_item.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final List<TabItem> _icons = TabItem.tabItems;

  int _selectedTab = 0;

  void _onInitRiveIcon(Artboard artboard, index) {
    final controller = StateMachineController.fromArtboard(
        artboard, _icons[index].stateMachine);
    artboard.addController(controller!);
    _icons[index].status = controller.findInput<bool>("active") as SMIBool;
  }

  void onTabPress(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });

      _icons[index].status?.change(true);
      Future.delayed(Duration(seconds: 1), () {
        _icons[index].status?.change(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: List.generate(_icons.length, (index) {
              TabItem icon = _icons[index];
              return Expanded(
                key: icon.id,
                child: MaterialButton(
                  padding: EdgeInsets.all(12),
                  child: AnimatedOpacity(
                    opacity: _selectedTab == index ? 1 : 0.5,
                    duration: Duration(milliseconds: 200),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: -6,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: _selectedTab == index ? 24 : 0,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: RiveAnimation.asset(
                            'assets/rive/icons.riv',
                            stateMachines: [icon.stateMachine],
                            artboard: icon.artboart,
                            onInit: (artboard) {
                              _onInitRiveIcon(artboard, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    onTabPress(index);
                  },
                ),
              );
            }),
          )),
    );
  }
}
