import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class SearchNotesBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const SearchNotesBar({
    required this.controller,
    super.key,
    required this.hintText,
    required this.onChanged,
  
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.only(
              left: 8,
            ),
            child: Icon(
              Icons.search,
              color: Color(0XFF71717A),
            ),
          ),
          contentPadding: const EdgeInsets.all(10),
          hintText: Locales.string(context, hintText),
          hintStyle: const TextStyle(
            color: Color(0xFF71717A),
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
