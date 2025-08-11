import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title:  Row(
        mainAxisSize: MainAxisSize.min,
        children: [
         SvgPicture.asset(
            'assets/images/note_logo.svg',
            width: 24 ,
            height: 24,
          ),
          const SizedBox(width: 4),
          const Text("Arfoon Note", style:TextStyle(fontSize: 16,)),
        ],
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
    );
  }
}
