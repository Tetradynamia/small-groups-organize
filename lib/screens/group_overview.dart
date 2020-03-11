import 'package:flutter/material.dart';
import 'package:t3/widgets/drawer.dart';

import '../widgets/groups_grid.dart';
import '../screens/manage_groups_screen.dart';

class GroupOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groups'),
      ),
      body: GroupsGrid(),
      drawer: MainDrawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(ManageGroupsScreen.routeName);
          },
          child: Icon(Icons.edit)),
    );
  }
}
