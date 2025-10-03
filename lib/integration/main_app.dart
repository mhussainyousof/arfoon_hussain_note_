import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/pages/home_page.dart';
import 'package:arfoon_note/frontend/widgets/profile_view_dialog.dart';
import 'package:arfoon_note/main.dart';
import 'package:arfoon_note/server/user_info.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isFirstTime = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final isFirstTime = await UserInfo.isFirstTime();
    setState(() {
      _isFirstTime = isFirstTime;
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
      home: _isFirstTime ?  _welcomeDialog() :  HomePage(),
    );
  }
  
  _welcomeDialog() {
    ProfileView(title:'welcome_to_arfoon_note', submitText: 'continue', currentName: '', onSubmit: (newName) async {
            await api.localStorageService.saveUserName(newName!);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }, ).show(context);
  }
}

