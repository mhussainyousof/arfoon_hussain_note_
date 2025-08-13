import 'package:arfoon_note/frontend/frontend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomDialgo extends StatelessWidget {
  const WelcomDialgo({super.key});

  @override
  Widget build(BuildContext context) {
    return NoteDialog(children: [
      SvgPicture.asset('assets/images/note_logo.svg', width: 60, height: 60),
      const SizedBox(height: 20),
      const Text(
        'Welcome to Arfoon Note',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      const SizedBox(
        height: 30,
      ),
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Full Name',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(height: 5),
      const NoteTextField(
        hintText: 'Full Name',
      ),
      const SizedBox(height: 20),
      dialogButtons(
          mainAxisAlignment: MainAxisAlignment.center,
          elevatedButtonOnpressed: () {},
          isTextButton: false,
          textButtonText: 'textButtonText',
          elevatedButtonText: 'Continue'),
     const SizedBox(height: 20),
RichText(
  textAlign: TextAlign.center,
  text: const TextSpan(
    style: TextStyle(
      fontSize: 14,
      color: Color(0xFFA2A2A2),
    ),
    children: [
      TextSpan(text: 'By using X note you agree to '),
      TextSpan(
        text: 'Terms of Services',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFFA2A2A2),
          decoration: TextDecoration.underline,
        ),
      ),
      TextSpan(text: ' and '),
      TextSpan(
        text: 'Privacy Policy',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFFA2A2A2),
          decoration: TextDecoration.underline,
        ),
      ),
    ],
  ),
),

    ]);
  }
}
