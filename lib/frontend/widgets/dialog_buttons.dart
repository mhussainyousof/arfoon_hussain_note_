import 'package:flutter/material.dart';

class dialogButtons extends StatelessWidget {
  final double? textButtonElevation;
  final void Function()? textButtonOnpressed;
  final void Function()? elevatedButtonOnpressed;
  final String textButtonText;
  final String elevatedButtonText;
  final MainAxisAlignment? mainAxisAlignment;
  final bool? isTextButton;
  final double? width;
  const dialogButtons({
    super.key,
    this.textButtonElevation,
    this.textButtonOnpressed,
    this.elevatedButtonOnpressed,
    required this.textButtonText,
    required this.elevatedButtonText,
    this.mainAxisAlignment,
    this.width,
    this.isTextButton,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
      children: [
        isTextButton == true
            ? Material(
                color: Colors.white,
                elevation: textButtonElevation ?? 1,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: textButtonOnpressed,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      textButtonText,
                      style: const TextStyle(
                        color: Color(0XFF646464),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        SizedBox(width: width),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10)),
                backgroundColor: Colors.black),
            onPressed: elevatedButtonOnpressed,
            child: Text(
              elevatedButtonText,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ))
      ],
    );
  }
}
