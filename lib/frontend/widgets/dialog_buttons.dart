import 'package:arfoon_note/frontend/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class DialogButtons extends StatefulWidget {
  final double? secondaryButtonElevation;
  final void Function()? secondaryButtonOnPressed;
  final Future<void> Function()? primaryButtonOnPressed;
  final String secondaryButtonText;
  final String primaryButtonText;
  final MainAxisAlignment? mainAxisAlignment;
  final bool? showTextButton;
  final double? spaceOfButtons;

  const DialogButtons({
    super.key,
    this.secondaryButtonElevation,
    this.secondaryButtonOnPressed,
    this.primaryButtonOnPressed,
    required this.secondaryButtonText,
    required this.primaryButtonText,
    this.mainAxisAlignment,
    this.spaceOfButtons,
    this.showTextButton,
  });

  @override
  State<DialogButtons> createState() => _DialogButtonsState();
}

class _DialogButtonsState extends State<DialogButtons> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
          
      children: [
        widget.showTextButton == true
            ? Column(
              children: [
                Material(
                    color: Colors.white,
                    elevation: widget.secondaryButtonElevation ?? 1,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: widget.secondaryButtonOnPressed,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical:6 ),
                        child: LocaleText(
                          widget.secondaryButtonText,
                          style: const TextStyle(
                            color: Color(0XFF646464),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6,)
              ],
            )
            : const SizedBox.shrink(),
        SizedBox(width: widget.spaceOfButtons),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: Colors.black),
            onPressed: isLoading
                ? null
                : () async {
                    if (widget.primaryButtonOnPressed != null) {
                      setState(() => isLoading = true);
                      try {
                        await widget.primaryButtonOnPressed!();
                      } catch (e) {
                        showDialog(
                          context: context, 
                          builder: (_) => NoteDialog(
                            title: "Error",
                            details: '$e',
                            children: [
                              DialogButtons(
                                secondaryButtonText: 'textButtonText',
                                primaryButtonText: 'Ok',
                                showTextButton: false,
                                primaryButtonOnPressed: () async {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        );
                      } finally {
                        if (mounted) setState(() => isLoading = false);
                      }
                    }
                  },
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(),
                  )
                : LocaleText(
                    widget.primaryButtonText,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ))
      ],
    );
  }
}
