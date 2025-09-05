import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/pages/home_page.dart';
import 'package:arfoon_note/server/local_storage_service.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool showWelcome = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final isFirstTime = await LocalStorageService.isFirstTime();
    setState(() {
      showWelcome = isFirstTime;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    return FrontendApp(
      home: showWelcome ? const WelcomeWrapper() :  HomePage(),
    );
  }
}

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