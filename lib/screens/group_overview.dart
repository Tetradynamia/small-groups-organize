import 'package:flutter/material.dart';
import 'package:t3/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:t3/widgets/start.dart';

import '../widgets/groups_grid.dart';
import '../screens/manage_groups_screen.dart';
import '../models/members_groups_model.dart';

class GroupOverview extends StatelessWidget {
  static const routeName = '/groups-overview';
  @override
  Widget build(BuildContext context) {
     print('building shit');
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Your Groups'),
      ),
      body: FutureBuilder(
          future: Provider.of<MembersGroupsModel>(context, listen: false)
              .fetchAndSetGroupsMembers(),
          builder: (ctx, dataSnapshot) {
            if (
                dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.error != null) {
              return const Center(child: const Text('An error occured!'));
            } else {
              return Provider.of<MembersGroupsModel>(context).groups.isEmpty
                  ?  Start()
                  : GroupsGrid();
            }
          }),
      drawer: MainDrawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(ManageGroupsScreen.routeName);
          },
          child: const Icon(Icons.edit)),
    );
  }
}
