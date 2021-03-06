import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/localizations/localization_constants.dart';


import '../widgets/manage_group_item.dart';
import '../widgets/start.dart';
import '../widgets/drawer.dart';
import '../models/members_groups_model.dart';
import '../screens/edit_groups_screen.dart';

class ManageGroupsScreen extends StatelessWidget {
  static const routeName = '/manage-groups';

  Future<void> _refreshData(
    BuildContext context,
  ) async {
    await Provider.of<MembersGroupsModel>(context, listen: false)
        .fetchAndSetGroupsMembers();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MembersGroupsModel>(context);
    final groups = data.groups;
    return Scaffold(
      appBar: AppBar(title:  Text(getTranslation(context, 'manage_groups'))),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
        child: groups.isEmpty
            ? Start()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) =>
                          ManageGroupsItem(groups[index]),
                      itemCount: groups.length,
                    ),
                  ),
                ]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                  shape:  RoundedRectangleBorder(
                    borderRadius:  BorderRadius.circular(10.0),
                  ),
                  title: Text(getTranslation(context, 'add_group')),
                  content: EditGroupsScreen(null)));
        },
      ),
    );
  }
}
