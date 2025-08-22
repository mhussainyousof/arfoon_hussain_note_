import 'package:arfoon_note/frontend/widgets/widget.dart';
import 'package:flutter/material.dart';

class dialogButtons extends StatefulWidget {
  final double? textButtonElevation;
  final void Function()? textButtonOnpressed;
  final Future<void> Function()? elevatedButtonOnpressed;
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
  State<dialogButtons> createState() => _dialogButtonsState();
}

class _dialogButtonsState extends State<dialogButtons> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
      children: [
        widget.isTextButton == true
            ? Material(
                color: Colors.white,
                elevation: widget.textButtonElevation ?? 1,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: widget.textButtonOnpressed,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      widget.textButtonText,
                      style: const TextStyle(
                        color: Color(0XFF646464),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        SizedBox(width: widget.width),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.black),
            onPressed: isLoading
                ? null
                : () async {
                    if (widget.elevatedButtonOnpressed != null) {
                      setState(() => isLoading = true);

                      try {
                        await widget.elevatedButtonOnpressed!();
                      } catch (e) {
                        showDialog(
                          context: context, 
                          builder: (_) => NoteDialog(
                            title: "Error",
                            details: '$e',
                            children: [
                              dialogButtons(
                                textButtonText: 'textButtonText',
                                elevatedButtonText: 'Ok',
                                isTextButton: false,
                                elevatedButtonOnpressed: () async {
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
                : Text(
                    widget.elevatedButtonText,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ))
      ],
    );
  }
}
