import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/main.dart';
import 'package:arfoon_note/server/local_storage_service.dart';
import 'package:flutter/material.dart';

  class HomePage extends StatelessWidget {
    const HomePage({super.key});

    void _handleProfileTap(BuildContext context) async {
    final currentName = await LocalStorageService.getUserName() ?? '';
    showDialog(
      context: context,
      builder: (context) =>
       ProfileEditDialog(
        currentName: currentName,
        onNameSaved:(newName)async{
        await LocalStorageService.saveUserName(newName);
        Navigator.pop(context);
        
        } ,
      ),
    );
  }


    @override
    Widget build(BuildContext context) {
      return HomeView(
        addNote: api.notes.insert,
        getNotes: api.notes.list,
        getLabels: api.labels.list,
        onProfileTap: ()=> _handleProfileTap(context)
      );
    }
  }
