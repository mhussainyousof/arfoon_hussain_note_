import 'package:arfoon_note/frontend/features/home/home_example.dart';
import 'package:arfoon_note/integration/main_app.dart';
import 'package:flutter/material.dart';

import 'widgets/widget.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Examples')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const ExampleButton(
            text: 'Home Example',
            route: HomeExample(),
          ),
          const ExampleButton(
            text: 'Main App',
            route: MainApp(),
          ),
          ExampleDialogButton(
            text: 'Delete Dialog',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return NoteDialog(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    title: 'Delete!',
                    details: 'Are you sure you want to delete it?',
                    children: [
                      const SizedBox(height: 20),
                      dialogButtons(
                        mainAxisAlignment: MainAxisAlignment.end,
                        width: 20,
                        textButtonElevation: 1,
                        textButtonText: 'Stop',
                        elevatedButtonText: 'Do it',
                        isTextButton: true,
                        elevatedButtonOnpressed: () {
                          Navigator.pop(context, true);
                        },
                        textButtonOnpressed: () {
                          Navigator.pop(context, false);
                        },
                      )
                    ],
                  );
                },
              );

              print('Dialog result: $confirm');
            },
          ),
          ExampleDialogButton(
              text: 'New Label',
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return NoteDialog(
                        title: 'New Label',
                        fontWeight: FontWeight.bold,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        details: 'Label Name',
                        children: [
                          // const Text(
                          //   'Label Name',
                          //   style: TextStyle(
                          //       fontSize: 14, fontWeight: FontWeight.w500),
                          // ),

                          const SizedBox(height: 8),
                          const NoteTextField(
                            hintText: 'A creative label name',
                          ),
                          const SizedBox(height: 40),

                          //! Buttons for deleting or saving the label
                          dialogButtons(
                            isTextButton: true,
                            elevatedButtonOnpressed: () {},
                            textButtonText: 'Delete',
                            elevatedButtonText: 'Save Label',
                            textButtonOnpressed: () {
                              //! Confirmation dialog for delete
                              showDialog(
                                context: context,
                                builder: (context) => NoteDialog(
                                  
                                  children: [
                                    
                                  const Text(
                                    'Are you sure want to Delete?',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                      'Once Deleted a label cannot be undo, are you sure want to Delete?',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 25),

                                  //! Cancel and Delete buttons in confirmation dialog
                                  dialogButtons(
                                      isTextButton: true,
                                      textButtonElevation: 0,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      width: 15,
                                      elevatedButtonOnpressed: () {},
                                      
                                      textButtonText: 'Cancel',
                                      elevatedButtonText: 'Delete It.')
                                ]),
                              );
                            },
                          )
                        ],
                      );
                    });
              })
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

class ExampleDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ExampleDialogButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
