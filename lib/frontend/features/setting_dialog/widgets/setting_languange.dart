import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingLanguage extends StatelessWidget {
  final String text;
  final String containerText;
  const SettingLanguage({
    super.key,required this.text, required this.containerText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: [
           Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF646464)),
            ),
          ),
      const SizedBox(height: 7),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE4E4E7)),
          borderRadius: BorderRadius.circular(8),
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              containerText
              , style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
            const Icon(Icons.unfold_more, color: Color(0xFF646464,
            ))
      
          ],
        ),
      )
        ],
      ),
    );
  }
}