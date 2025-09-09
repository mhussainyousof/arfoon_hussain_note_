import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/cubit/await_cubit/await_cubit.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

  class HomePage extends StatelessWidget {
    const HomePage({super.key});
    @override
    Widget build(BuildContext context) {
      return HomeView(
        addNote: api.noteServer.notes.insert,
        getNotes: api.noteServer.notes.list,
        getLabels: api.noteServer.labels.list,
        onProfileTap: ()=> _handleProfileTap(context)
      );
    }


    void _handleProfileTap(BuildContext context) async {
    final currentName = await api.localStorageService.getUserName(null) ?? '';
    showDialog(
      context: context,
      builder: (context) =>
       ProfileEditDialog(
        currentName: currentName,
        onNameSaved:(newName)async{
        await api.localStorageService.saveUserName(newName);
        
        Navigator.pop(context);
        
        },
      ),
    );
  }
  }
