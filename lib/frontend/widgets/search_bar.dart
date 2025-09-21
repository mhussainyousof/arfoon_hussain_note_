import 'package:arfoon_note/frontend/theme/responsive.dart';
import 'package:arfoon_note/frontend/widgets/widget.dart';
import 'package:flutter/material.dart';

class SearchNotesBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final EdgeInsetsGeometry? prefixIconPadding;
  const SearchNotesBar({
    required this.controller,
    super.key,
    required this.hintText,
    required this.onChanged, this.prefixIconPadding,
    
  
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, ),
      child: CustomeTextField(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
        controller: controller,
        onChanged: onChanged,
        prefixIcon: const Icon(Icons.search),
        hintText: hintText,
        
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 30),
      ),
    );
  }
}
