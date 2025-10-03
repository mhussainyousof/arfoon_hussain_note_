import 'package:arfoon_note/frontend/features/home/home_example.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/frontend/widgets/sure_dialog_view.dart';
import 'package:arfoon_note/integration/main_app.dart';
import 'package:arfoon_note/frontend/widgets/profile_dialog_view.dart';
import 'package:arfoon_note/main.dart';
import 'package:arfoon_note/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bidi_text/bidi_text.dart';
import 'package:flutter_locales/flutter_locales.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({
    super.key,
  });

  @override
  State<ExamplePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: BidiText(
          Locales.string(context, 'examples'),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const ListTileWidget(
                route: HomeExample(), 
                title: 'Home Example',
                subTitle:
                    'Push to HomeExample and Example returns HomeView with calls of getNote(file), getLabels, addNote, onSettingTap, onProfileTap.',
              ),
               ListTileWidget(
                onTap: (){
                  ProfileView(onSubmit: (value) { },
                  submitText: '',
                  title: '',
                  currentName: ''
                  ).show(context);
                },
                title: 'Profile View',
                subTitle:
                    'This is a dialog and show as ProfileView().show(context) and has parameters of: title, submitText, onSubmit(s)',
              ),
              ListTileWidget(
                onTap: (){
                  SettingView(currentLanguage: Locales.lang, onLanguageChanged: (lang){}, currentTheme: ThemeState.dark, onThemeChanged: (t){}).show(context);
                },
                title: 'Setting view',
                subTitle:
                    'This is a dialog and show as SettingsView().show(context) and has parameters of currentLanguage, onLanguageChanged(llang), currentTheme, onThemeChanged(t)',
              ),
              ListTileWidget(
                route: AddEditNoteView(
                  getLabels: api.noteServer.labels.list,
                  onSave:api.noteServer.notes.insert,
                  initialLabel:null,
                  note: null,
                ), 
                title: 'Add Edit Label View',
                subTitle:
                    'This is a dialog and show as AddEditLabelView().show(context) and has parameters of: title, onSubmit(s), onDelete',
              ),
              ListTileWidget(
                onTap:(){
                   SureView(title: 'confirm_delete', subTitle: 'delete_warning', sureText: 'delete', onSure: ()async{
                }).show(context);
                },
                title: 'Sure View',
                subTitle:
                    'This is a dialog and show as SureView(title: , subtitle: , sureText: , onSure: async (){}).show(context)',
              ),
          
              const ListTileWidget(title: 'Main App', subTitle: '', route: MainApp(),)
            ],
          ),
        ),
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  final Widget? route;
  final Widget? dialog;
  final String title;
  final String subTitle;
  final VoidCallback? onTap;

  const ListTileWidget({
    super.key,
    this.route,
    this.dialog,
    required this.title,
    required this.subTitle, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
     
      onTap: onTap ?? () {
        
        if (route != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route!));
        } else if (dialog != null) {
          showDialog(
            context: context,
            builder: (context) => dialog!,
          );
        }
      },
      title: BidiText(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
      subtitle: BidiText(subTitle),
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
