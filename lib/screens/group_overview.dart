import 'package:flutter/material.dart';
import 'package:t3/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:t3/widgets/start.dart';


import '../widgets/groups_grid.dart';
import '../screens/manage_groups_screen.dart';
import '../models/members_groups_model.dart';

class GroupOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groups'),
      ),
      body: FutureBuilder(
          future: Provider.of<MembersGroupsModel>(context, listen: false)
              .fetchAndSetGroupsMembers(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.error != null) {
              return Center(child: Text('An error occured!'));
            } else {
              return Provider.of<MembersGroupsModel>(context).groups.isEmpty
                  ? Start()
                  : GroupsGrid();
            }
          }),
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
