import 'package:flutter/material.dart';
import 'package:t3/screens/manage_groups_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Hello!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Group overview"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage groups"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ManageGroupsScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
