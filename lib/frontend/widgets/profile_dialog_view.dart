import 'package:flutter/material.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

class ProfileView {
  final String title;
  final String submitText;
  final ValueChanged<String?> onSubmit;
  final String? currentName;
  ProfileView({
    this.currentName,
    required this.title,
    required this.submitText,
    required this.onSubmit,
  });

  void show(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return ProfileViewDialog(
              currentName: currentName ?? '',
              onSubmit: onSubmit,
              title: title,
              submitText: submitText);
        });
  }
}

class ProfileViewDialog extends StatefulWidget {
  final String currentName;
  final ValueChanged<String> onSubmit;
  final String title;
  final String submitText;
  const ProfileViewDialog(
      {super.key,
      required this.currentName,
      required this.onSubmit,
      required this.title,
      required this.submitText});

  @override
  State<ProfileViewDialog> createState() => _ProfileViewDialogState();
}

class _ProfileViewDialogState extends State<ProfileViewDialog> {
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
      title: 'edit_label',
      fontWeight: FontWeight.bold,
      crossAxisAlignment: CrossAxisAlignment.start,
      details: 'label_name',
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
        LocaleText(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 30),

        //!
        // Label text for full name
        Align(
          alignment:
              isRTL(context) ? Alignment.centerRight : Alignment.centerLeft,
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
              widget.onSubmit(name);
            }
            Navigator.pop(context);
          },
          showTextButton: widget.currentName.isNotEmpty,
          secondaryButtonText: 'cancel',
          primaryButtonText: widget.submitText,
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
