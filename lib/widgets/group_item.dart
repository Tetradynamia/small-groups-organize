import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../localizations/localization_constants.dart';
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
        groupData.members.where((member) => member.groupId == id);
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(50)),
      onTap: () {
        Navigator.of(context).pushNamed(TabsScreen.routeName, arguments: id);
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
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(70)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
               Text(getTranslation(context, 'members')),
              Consumer<MembersGroupsModel>(
                builder: (ctx, data, _) => Text(
                  '${thisGroupMembers.length}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  description,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
