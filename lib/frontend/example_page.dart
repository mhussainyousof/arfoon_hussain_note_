import 'package:arfoon_note/frontend/features/home/home_example.dart';
import 'package:arfoon_note/integration/main_app.dart';
import 'package:flutter/material.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examples')),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ExampleButton(
            text: 'Home Example',
            route: HomeExample(),
          ),
          ExampleButton(
            text: 'Main App',
            route: MainApp(),
          ),
        ],
      ),
    );
  }
}

class ExampleButton extends StatelessWidget {
  final String text;
  final Widget route;

  const ExampleButton({
    super.key,
    required this.text,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        },
        child: Text(text),
      ),
    );
  }
}
