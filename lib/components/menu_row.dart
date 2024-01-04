import 'package:flutter/material.dart';
import 'package:flutter_rive/models/menu_item.dart';
import 'package:rive/rive.dart';

class MenuRow extends StatelessWidget {
  const MenuRow({super.key, required this.menuItem});

  final MenuItem menuItem;

  void _onMenuInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, menuItem.riveIcon.stateMachine);
    artboard.addController(controller!);
    menuItem.riveIcon.status = controller.findInput<bool>("active") as SMIBool;
  }

  void onMenuPressed() {
    menuItem.riveIcon.status?.change(true);
    Future.delayed(Duration(seconds: 1), () {
      menuItem.riveIcon.status?.change(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(12),
      onPressed: onMenuPressed,
      child: Row(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Opacity(
              opacity: 0.6,
              child: RiveAnimation.asset(
                'assets/rive/icons.riv',
                stateMachines: [menuItem.riveIcon.stateMachine],
                artboard: menuItem.riveIcon.artboart,
                onInit: _onMenuInit,
              ),
            ),
          ),
          SizedBox(width: 14),
          Text(
            menuItem.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
