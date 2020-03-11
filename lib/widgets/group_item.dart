import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/tabs_screen.dart';
import '../models/members_groups_model.dart';

class GroupItem extends StatelessWidget {
  final String id;
  final String name;
  final String description;

  GroupItem(
    this.id,
    this.name,
    this.description,
  );

  @override
  Widget build(BuildContext context) {
    final groupData = Provider.of<MembersGroupsModel>(context);
    final thisGroupMembers =
        groupData.members.where((member) => member.groupName == name);
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(50)),
      onTap: () {
        Navigator.of(context).pushNamed(TabsScreen.routeName, arguments: name);
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.7),
              Theme.of(context).primaryColor
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(50)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Column(
              children: <Widget>[
                Text('Members;'),
                Text(
                  '${thisGroupMembers.length}',
                  style: TextStyle(fontSize: 20, color: Colors.white
                  ),
                ),
              ],
            ),
            Text(description, style: TextStyle( color: Colors.white),),
          ],
        ),
      ),
    );
  }
}
