import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/widgets/manage_group_item.dart';

import '../widgets/drawer.dart';
import '../models/members_groups_model.dart';
import '../screens/edit_groups_screen.dart';

class ManageGroupsScreen extends StatelessWidget {
  static const routeName = '/manage-groups';

  Future <void> _refreshData (BuildContext context,) async {
   await Provider.of<MembersGroupsModel>(context, listen: false).fetchAndSetGroupsMembers();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MembersGroupsModel>(context);
    final groups = data.groups;
    return Scaffold(
      appBar: AppBar(title: const Text('Manage your groups')),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
              child: Column(children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => ManageGroupsItem(groups[index]),
              itemCount: groups.length,
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                  title: const Text('Add group'), content: EditGroupsScreen(null)));
        },
      ),
    );
  }
}
