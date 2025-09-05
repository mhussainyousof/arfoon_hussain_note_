import 'package:arfoon_note/frontend/frontend.dart';
import 'package:flutter/material.dart';
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
    return NoteDialog(
      children: [
        //!
        //App logo
        SvgPicture.asset('assets/images/note_logo.svg', width: 60, height: 60),
        const SizedBox(height: 20),

        //!
        //Welcome message
        Text(
          widget.currentName.isEmpty
              ? 'Welcome to Arfoon Note'
              : 'Edit Profile',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 30),

        //!
        // Label text for full name
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Full Name',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 5),

        //!
        //text field for user to enter their full name
        CustomeTextField(
          controller: _nameController,
          hintText: 'Full Name',
        ),
        const SizedBox(height: 20),

        //!
        // Dialog action buttons
        DialogButtons(
          mainAxisAlignment: MainAxisAlignment.center,
          primaryButtonOnPressed: () async {
            final name = _nameController.text.trim();
            if (name.isNotEmpty) {
              widget.onNameSaved(name);
            }
          },
          showSecondary: widget.currentName.isNotEmpty,
          secondaryButtonText: 'Cancel',
          primaryButtonText:
              widget.currentName.isEmpty ? 'Continue' : 'Save Changes',
          secondaryButtonOnPressed: () => Navigator.pop(context),
        ),




        if (widget.currentName.isEmpty) const SizedBox(height: 20),


        //!
        //terms and privacy
        if (widget.currentName.isEmpty)
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFA2A2A2),
              ),
              children: [
                TextSpan(text: 'By using X note you agree to '),
                TextSpan(
                  text: 'Terms of Services',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA2A2A2),
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    fontSize: 14,
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
