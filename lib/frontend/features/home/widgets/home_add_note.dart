import 'package:flutter/material.dart';

class AddNoteButton extends StatelessWidget {

  final Widget? child;
  final VoidCallback? onPressed;
  const AddNoteButton({super.key,  this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: onPressed,
      backgroundColor: Colors.black,
      child: child
    );
  }
}
