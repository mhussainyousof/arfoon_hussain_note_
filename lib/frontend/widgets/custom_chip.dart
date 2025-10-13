import 'package:flutter/material.dart';

class NoteChip extends StatelessWidget {
  final String text;
  final VoidCallback? onDeleted;
  final Color backgroundColor;
  final TextStyle labelStyle;
  final BorderRadius? borderRadius; 

  const NoteChip({
    super.key,
    required this.text,
    this.onDeleted,
    this.backgroundColor = const Color(0xfff4f4f5),
    this.labelStyle = const TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {

    //!
    // chip to show labels
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 7,),
      label: Text(text),
      backgroundColor: backgroundColor,
      elevation: 0,
      padding: const EdgeInsets.all(0),
      side: BorderSide.none,
      shape: borderRadius != null
          ? RoundedRectangleBorder(borderRadius: borderRadius!)
          : const StadiumBorder(),
      labelStyle: labelStyle,
      deleteIcon: onDeleted != null
          ? const Icon(Icons.close, size: 15)
          : null,
      onDeleted: onDeleted,
    );
  }
}
