import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  final CrossAxisAlignment? crossAxisAlignment;
  final List<Widget> children;
  const NoteDialog({
    super.key, this.crossAxisAlignment, required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadiusGeometry.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: children
          ),
        ),
      ),
    );
  }
}
