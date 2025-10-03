import 'package:flutter/material.dart';
import 'package:flutter_bidi_text/flutter_bidi_text.dart';
import 'package:flutter_locales/flutter_locales.dart';

class SettingOption extends StatelessWidget {
  final String labelKey;
  final String valueText;
  final VoidCallback? onPressed;
  final bool isLocaleText;
  const SettingOption({
    super.key,
    required this.labelKey,
    this.isLocaleText = true,
    required this.valueText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BidiText(
            Locales.string(context, labelKey),
            style: const TextStyle(fontSize: 13, color: Color(0xFF646464)),
          ),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isLocaleText
                    ? LocaleText(valueText,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))
                    : Text(valueText,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: onPressed,
                  child: const Icon(
                    Icons.unfold_more,
                    color: Color(0xFF646464),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
