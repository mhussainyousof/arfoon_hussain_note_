import 'package:arfoon_note/frontend/features/add_note/add_note_view.dart';
import 'package:flutter/material.dart';

class AddNoteExample extends StatelessWidget {
  const AddNoteExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AddNoteView(
      updatedAt: 'Dec 17',
      title: '',
      description: '',
      labels: const ['Office'],
      availableColors: const [Colors.blue, Colors.orange, Colors.green],
      selectedColor: Colors.blue,
      onBack: () => Navigator.pop(context),
      onMore: () => debugPrint('More clicked'),
      onTitleChanged: (value) => debugPrint('Title: $value'),
      onDescriptionChanged: (value) => debugPrint('Description: $value'),
      onColorSelected: (color) => debugPrint('Color selected: $color'),
      onAddLabel: (label) => debugPrint('Add label: $label'),
    );
  }
}
