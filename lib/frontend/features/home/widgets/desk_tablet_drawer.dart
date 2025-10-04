import 'package:arfoon_note/integration/integration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

class DesktopAndTabletDrawer extends StatelessWidget {
  const DesktopAndTabletDrawer({
    super.key,
    required this.isDark,
    required this.drawerWidget,
  });

  final bool isDark;
  final DrawerPage drawerWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/note_logo.svg',
                    colorFilter: ColorFilter.mode(
                      isDark ? Colors.white : Colors.black,
                      BlendMode.srcIn,
                    ),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const LocaleText(
                    'arfoon_note',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(child: drawerWidget),
          ],
        ));
  }
}
