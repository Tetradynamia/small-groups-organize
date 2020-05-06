import 'package:flutter/material.dart';


import '../screens/group_overview.dart';
import '../screens/manage_groups_screen.dart';
import '../screens/settings_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text("small groups - ORGANIZE!"),
            automaticallyImplyLeading: false,
          ),
        const  Divider(),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text("Group overview"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(GroupOverview.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Manage groups"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageGroupsScreen.routeName);
            },
          ),
         const Divider(),
         ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SettingsScreen.routeName);
            },
          ),
         const Divider(),
      
        ],
      ),
    );
  }
}
