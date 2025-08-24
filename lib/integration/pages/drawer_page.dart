import 'package:arfoon_note/frontend/features/drawer/drawer.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDrawer(
        getLabels: api.labels.list,
        addLabel:api.labels.insert,
        deleteLabel: api.labels.deleteLabel,
        updateLabel: api.labels.updateLabel,
      userGreeting: 'Good Morning ',
      userName: 'AbdulRahman Popal' ,
    );
  }
}