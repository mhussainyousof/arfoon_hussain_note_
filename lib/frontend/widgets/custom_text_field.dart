import 'package:flutter/material.dart';
import 'package:flutter_bidi_text/flutter_bidi_text.dart';
import 'package:flutter_locales/flutter_locales.dart';

class CustomeTextField extends StatelessWidget {
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
  final FontWeight? fontWeight;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final  void Function(String)? onSubmitted;

  const CustomeTextField({
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
    this.suffixIcon, this.onChanged, this.fontWeight, this.onSubmitted,
  });

  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: hasBorder ? Border.all(color: borderColor, width: borderWidth) : null,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: BidiTextField(
        onSubmitted: onSubmitted,
        onChanged:onChanged ,
        controller: controller,
        focusNode: focusNode, 
        maxLines: isMultiline ? maxLines : 1,
        decoration: InputDecoration(
          hintText: Locales.string(context, hintText!),
          hintStyle: TextStyle(
          fontSize: hintSize ?? 14, color: const Color.fromARGB(255, 150, 150, 158), fontWeight: fontWeight),
          border: InputBorder.none,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isDense: true,
          contentPadding: const EdgeInsets.all(8)

        ),
      ),
    );
  }
}
