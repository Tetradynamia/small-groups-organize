import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/screens/group_overview.dart';

import '../screens/manage_groups_screen.dart';
import '../models/auth.dart';
import '../models/members_groups_model.dart';

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
          ListTile(
            leading: Provider.of<MembersGroupsModel>(context).mode == Mode.LocalMode ? Icon(Icons.swap_horiz) : Icon(Icons.exit_to_app)  ,
            title:  Text( Provider.of<MembersGroupsModel>(context).mode == Mode.LocalMode ? 'Switch to cloud mode' : "Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/');
             Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
