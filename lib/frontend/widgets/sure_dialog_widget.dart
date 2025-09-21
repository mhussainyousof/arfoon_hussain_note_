import 'package:arfoon_note/frontend/frontend.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SureView {
  final String title;
  final String subTitle;
  final String sureText;
  final AsyncCallback onSure;
  SureView({
    required this.title,
    required this.subTitle,
    required this.sureText,
    required this.onSure,
  });

  void show(BuildContext context) {
    showDialog(
      useRootNavigator: false,
        context: context,
        builder: (context) {
          return NoteDialog(
            crossAxisAlignment: CrossAxisAlignment.start,
            title: title, details: subTitle,
            children: [
            const SizedBox(height: 15),
            DialogButtons(
                showTextButton: true,
                secondaryButtonElevation: 0,
                mainAxisAlignment: MainAxisAlignment.end,
                space_of_buttons: 15,
                primaryButtonOnPressed: () async {
                  await onSure();
                  Navigator.pop(context);
                },
                secondaryButtonOnPressed: () {
                  Navigator.pop(context);
                },
                secondaryButtonText: 'cancel',
                primaryButtonText: sureText)
          ]);
        }); 
  }
}
