
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:arfoon_note/frontend/widgets/widget.dart';

class AddEditLabelView {
  final String title;
  final String details;
  final ValueChanged<String> onSubmit;
  final VoidCallback? onDelete;
  final String? initialValue;

  AddEditLabelView(
    {
    this.initialValue, 
    required this.details,
    required this.title,
    required this.onSubmit,
    required this.onDelete,
  });

  void show(BuildContext context) {
    showDialog(
        useRootNavigator: false,
        context: context,
        builder: (context) {
          final controller = TextEditingController(text: initialValue ?? '');
          return NoteDialog(title: title, details: details, children: [
            const SizedBox(height: 8),
            CustomeTextField(
              controller: controller,
              hintText: 'enter_label_name',
            ),
            const SizedBox(height: 40),

            DialogButtons(
              showTextButton: true,
              secondaryButtonText: initialValue != null ?  'delete' : 'cancel',
              primaryButtonText: initialValue != null ? 'update' : 'save_label',
              secondaryButtonOnPressed: onDelete,
              primaryButtonOnPressed: ()async{
                final label = controller.text.trim();
                if (label.isNotEmpty) {
                   onSubmit(label);
                   Navigator.pop(context);
                }
              },
            ),
          ]);
        });
  }
}
