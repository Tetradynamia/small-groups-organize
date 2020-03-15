import 'package:flutter/material.dart';
import 'package:t3/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:t3/widgets/start.dart';

import '../widgets/groups_grid.dart';
import '../screens/manage_groups_screen.dart';
import '../models/members_groups_model.dart';

class GroupOverview extends StatefulWidget {
  @override
  _GroupOverviewState createState() => _GroupOverviewState();
}

class _GroupOverviewState extends State<GroupOverview> {
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    Provider.of<MembersGroupsModel>(context, listen: false)
        .fetchAndSetGroupsMembers()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groupData = Provider.of<MembersGroupsModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groups'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : groupData.groups.isNotEmpty ? GroupsGrid() : Start(),
      drawer: MainDrawer(),
      floatingActionButton: Visibility(
        visible: groupData.groups.isNotEmpty ? true : false,
        child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageGroupsScreen.routeName);
            },
            child: Icon(Icons.edit)),
      ),
    );
  }
}
