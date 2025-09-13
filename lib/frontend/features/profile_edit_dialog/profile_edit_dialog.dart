import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/cubit/await_cubit/await_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

class ProfileEditDialog extends StatefulWidget {
  final String currentName;
  final ValueChanged<String> onNameSaved;
  const ProfileEditDialog(
      {super.key, required this.currentName, required this.onNameSaved});

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  final TextEditingController _nameController = TextEditingController();
  final userNameCubit = AwaitCubit<String?>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return NoteDialog(
      children: [
        //!
        //App logo
        SvgPicture.asset(
          'assets/images/note_logo.svg',
          width: 60,
          height: 60,
          colorFilter: ColorFilter.mode(
            isDark ? Colors.white : Colors.black,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 20),

        //!
        //Welcome message
        Text(
          widget.currentName.isEmpty
              ? 'welcome_to_arfoon_note'
              : 'edit_profile',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 30),

        //!
        // Label text for full name
         Align(
          
          alignment:  isRTL(context) ? Alignment.centerRight : Alignment.centerLeft,
          child: const LocaleText(
            'full_name',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),

        //!
        //text field for user to enter their full name
        CustomeTextField(
          controller: _nameController,
          hintText: 'full_name',
        ),
        const SizedBox(height: 20),

        //!
        // Dialog action buttons
        DialogButtons(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          primaryButtonOnPressed: () async {
            final name = _nameController.text.trim();
            if (name.isNotEmpty) {
              widget.onNameSaved(name);
              
            }
          },
          showSecondary: widget.currentName.isNotEmpty,
          secondaryButtonText: 'cancel',
          primaryButtonText: widget.currentName.isEmpty ? 'continue' : 'save',
          secondaryButtonOnPressed: () => Navigator.pop(context),
        ),

        if (widget.currentName.isEmpty) const SizedBox(height: 20),

        const SizedBox(height: 20),
        //!
        //terms and privacy
        if (widget.currentName.isEmpty)
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFA2A2A2),
            ),
            children: [
              const TextSpan(text: ' '),
              TextSpan(text: Locales.string(context, 'terms_text')),
              TextSpan(
                text: Locales.string(context, 'terms'),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFA2A2A2),
                  decoration: TextDecoration.underline,
                ),
              ),
              TextSpan(
                text: Locales.string(context, 'services'),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFA2A2A2),
                ),
              ),
              TextSpan(text: Locales.string(context, 'and')),
              TextSpan(
                text: Locales.string(context, 'privacy_policy'),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFA2A2A2),
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
