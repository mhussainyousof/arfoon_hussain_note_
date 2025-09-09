import 'package:arfoon_note/frontend/features/profile_edit_dialog/profile_wrapper.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/pages/home_page.dart';
import 'package:arfoon_note/server/user_profile.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
  });

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
    final isFirstTime = await UserInfo.isFirstTime();
    setState(() {
      showWelcome = isFirstTime;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    return FrontendApp(
      home: showWelcome ? const WelcomeWrapper() : const HomePage(),
    );
  }
}
