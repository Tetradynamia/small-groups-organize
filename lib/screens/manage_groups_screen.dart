import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/widgets/manage_group_item.dart';

import '../widgets/drawer.dart';
import '../models/members_groups_model.dart';
import '../screens/edit_groups_screen.dart';

class ManageGroupsScreen extends StatelessWidget {
  static const routeName = '/manage-groups';

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MembersGroupsModel>(context);
    final groups = data.groups;
    return Scaffold(
      appBar: AppBar(title: Text('Manage your groups')),
      drawer: MainDrawer(),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, index) => ManageGroupsItem(groups[index]),
            itemCount: groups.length,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                  title: Text('Add group'), content: EditGroupsScreen(null)));
        },
      ),
    );
  }
}
