import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  final String? hintText;
  final double? hintSize;
  final TextEditingController? controller; 
  const NoteTextField({
    super.key,
    this.hintText,
    this.hintSize,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: hintSize ?? 14,
          color: const Color(0XFF71717A),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFFE4E7E7)),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0XFFE4E7E7),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      ),
    );
  }
}
