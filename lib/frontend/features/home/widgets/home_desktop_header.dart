import 'package:arfoon_note/frontend/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class DesktopHeader extends StatelessWidget {
  final VoidCallback createNote;
  const DesktopHeader({super.key, required this.createNote});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  LocaleText(
                    'my_notes',
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: isRTL(context) ? 18 : 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 6,
                  )
                ],
              ),

              //!
              // add new note 
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: () => createNote(),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.add,
                        size: 14,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      LocaleText(
                        'new',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }
}
