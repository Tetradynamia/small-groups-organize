import 'package:flutter/material.dart';

import 'package:t3/screens/group_overview.dart';

import '../screens/manage_groups_screen.dart';

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
          Divider(),
      
        ],
      ),
    );
  }
}
