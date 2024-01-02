import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  SMIBool? status;

  void _onInitRiveIcon(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "SEARCH_Interactivity");
    artboard.addController(controller!);
    status = controller.findInput<bool>("active") as SMIBool;
  }

  void onTabPress() {
    status?.change(true);
    Future.delayed(Duration(seconds: 6), () {
      status?.change(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.red),
      child: MaterialButton(
        child: RiveAnimation.asset(
          'assets/rive/icons.riv',
          stateMachines: ["SEARCH_Interactivity"],
          artboard: "SEARCH",
          onInit: _onInitRiveIcon,
        ),
        onPressed: onTabPress,
      ),
    );
  }
}
