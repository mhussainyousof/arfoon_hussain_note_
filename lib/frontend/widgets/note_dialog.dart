import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  final CrossAxisAlignment? crossAxisAlignment;
  final List<Widget> children;
  final String? title;
  final String? details;
  final FontWeight? fontWeight;
  final double? detailsHeight;
  final double? titleSize;

 
  const NoteDialog(
      {super.key,
      this.crossAxisAlignment,
      required this.children,
      this.title,
      this.fontWeight,
      this.titleSize,
      this.detailsHeight,
      this.details});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style:  TextStyle(
                    fontSize: titleSize ?? 20,
                    fontWeight: fontWeight ?? FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
              ],
              
              if (details != null) ...[
                Text(
                  details!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                //  SizedBox(height:  detailsHeight ??  0),
              ],
              ...children
            ]),
      ),
    );
  }
}
