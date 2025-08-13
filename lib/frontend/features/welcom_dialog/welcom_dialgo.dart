import 'package:arfoon_note/frontend/frontend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomDialgo extends StatelessWidget {
  const WelcomDialgo({super.key});

  @override
  Widget build(BuildContext context) {
    return NoteDialog(
      //! Main dialog container with a vertical list of widgets (children)
      children: [
        //! App logo displayed at the top of the dialog
        SvgPicture.asset('assets/images/note_logo.svg', width: 60, height: 60),
        const SizedBox(height: 20),

        //! Welcome message text with medium bold styling
        const Text(
          'Welcome to Arfoon Note',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 30),

        //! Label text for full name input aligned to the left
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Full Name',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 5),

        //! Custom text field for user to enter their full name
        const NoteTextField(
          hintText: 'Full Name',
        ),
        const SizedBox(height: 20),

        //! Dialog action buttons centered horizontally
        dialogButtons(
          mainAxisAlignment: MainAxisAlignment.center,
          elevatedButtonOnpressed: () {},  
          isTextButton: false,              
          textButtonText: 'textButtonText', 
          elevatedButtonText: 'Continue',
        ),
        const SizedBox(height: 20),

        //! Informational text about terms and privacy with underlined links
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
      ],
    );
  }
}

