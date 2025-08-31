import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  final String? hintText;
  final double? hintSize;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isMultiline;
  final int? maxLines;
  final Color borderColor;
  final double borderWidth;
  final bool hasBorder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;

  const NoteTextField({
    super.key,
    this.hintText,
    this.hintSize,
    this.controller,
    this.focusNode,
    this.borderRadius,
    this.padding,
    this.isMultiline = false,
    this.maxLines,
    this.borderColor = const Color(0xFFE4E7E7),
    this.borderWidth = 1,
    this.hasBorder = true,
    this.prefixIcon,
    this.suffixIcon, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: hasBorder ? Border.all(color: borderColor, width: borderWidth) : null,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged:onChanged ,
        controller: controller,
        focusNode: focusNode,
        maxLines: isMultiline ? maxLines : 1,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: hintSize ?? 14, color: const Color(0xFF71717A)),
          border: InputBorder.none,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          
        ),
      ),
    );
  }
}
