import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  final CrossAxisAlignment? crossAxisAlignment;
  final List<Widget> children;
  final String? title;
  final String? details;
  const NoteDialog({
    super.key,
    this.crossAxisAlignment,
    required this.children,
    this.title,
    this.details
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(

      
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if(title != null)Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    
                  ),
                ),
                const SizedBox(height: 15),
                if(details != null)Text(
                  details!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
              

              ...children
              ]),
        ),
      ),
    );
  }
}
