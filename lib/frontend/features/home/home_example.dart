import 'package:arfoon_note/frontend/frontend.dart';
import 'package:flutter/material.dart';

class HomeExample extends StatelessWidget {
  const HomeExample({super.key});
  @override
  Widget build(BuildContext context) {
    return HomeView(
      getLabels: (p0) => Future.delayed(const Duration(seconds: 2)),
      addNote: (n) async {
        await Future.delayed(const Duration(seconds: 1));
        return n.copyWith(id: 11);
      },
      getNotes: (f) async {
        await Future.delayed(const Duration(seconds: 1));
        return [];
      },

      onProfileTap: (){
        showDialog(context: context, builder: (context)=> ProfileEditDialog(currentName: 'Test User', onNameSaved: (name){
          print('Name would be saved $name');
          Navigator.pop(context);
        }));
      },
    
    );
  }
}
