import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../widgets/start.dart';
import '../widgets/drawer.dart';
import '../widgets/groups_grid.dart';
import '../screens/manage_groups_screen.dart';
import '../models/members_groups_model.dart';
import '../localizations/applocalization.dart';

class GroupOverview extends StatelessWidget {
  static const routeName = '/groups-overview';
  @override
  Widget build(BuildContext context) {
     
    return  Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)
                  .getTranslatedValue('home_page')),
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
