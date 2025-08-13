import 'package:arfoon_note/frontend/features/setting_dialog/widgets/setting_languange.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:flutter/material.dart';

class SettingDialog extends StatelessWidget {
  const SettingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoteDialog(children: [
      Icon(Icons.settings, size: 60, ),
      SizedBox(height: 20),
      Text(
        'Welcome to Arfoon Note',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      SizedBox(
        height: 30,
      ),
      SettingLanguage(
        text: 'Change Language',
        containerText: 'English',
      ),
      SizedBox(height: 20),
      SettingLanguage(
        text: 'Change Theme',
        containerText: 'System Theme',
      ),

    ]);
  }
}


