import 'package:flutter/material.dart';
import 'package:flutter_rive/models/menu_item.dart';
import 'package:rive/rive.dart';

class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.menuItem,
    this.selectedMenu = "Home",
    this.onMenuPress,
  });

  final MenuItem menuItem;
  final String selectedMenu;
  final Function? onMenuPress;

  void _onMenuInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, menuItem.riveIcon.stateMachine);
    artboard.addController(controller!);
    menuItem.riveIcon.status = controller.findInput<bool>("active") as SMIBool;
  }

  void onMenuPressed() {
    if (selectedMenu != menuItem.title) {
      onMenuPress!();
      menuItem.riveIcon.status?.change(true);
      Future.delayed(Duration(seconds: 1), () {
        menuItem.riveIcon.status?.change(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: selectedMenu == menuItem.title ? 280 - 16 : 0,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        MaterialButton(
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
        ),
      ],
    );
  }
}
