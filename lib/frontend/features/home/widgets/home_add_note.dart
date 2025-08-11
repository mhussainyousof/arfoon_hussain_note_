import 'package:flutter/material.dart';

class AddNoteButton extends StatelessWidget {
  const AddNoteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () {},
      backgroundColor: Colors.black,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
