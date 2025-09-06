import 'package:arfoon_note/frontend/features/profile_edit_dialog/profile_edit_dialog.dart';
import 'package:arfoon_note/integration/pages/home_page.dart';
import 'package:arfoon_note/server/local_storage_service.dart';
import 'package:flutter/material.dart';

class WelcomeWrapper extends StatefulWidget {
  const WelcomeWrapper({super.key});

  @override
  State<WelcomeWrapper> createState() => _WelcomeWrapperState();
}

class _WelcomeWrapperState extends State<WelcomeWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProfileEditDialog(
        currentName: '', // Empty for first time
        onNameSaved: (name) async {
          await LocalStorageService.saveUserName(name);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  HomePage()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}