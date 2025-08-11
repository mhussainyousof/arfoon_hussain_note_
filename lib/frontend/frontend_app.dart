import 'package:flutter/material.dart';

class FrontendApp extends StatelessWidget {
  const FrontendApp({super.key, required this.home});
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arfoon Note',
      theme: ThemeData(
        fontFamily: 'Geist',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
