import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/members_groups_model.dart';
import '../widgets/group_item.dart';

class GroupsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final groupsData = Provider.of<MembersGroupsModel>(context);
    final groups = groupsData.groups;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: groups.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: groups[index],
        child: GroupItem(
          groups[index].groupId,
          groups[index].groupName,
          groups[index].groupDescription,
          groups[index].groupMembers,
        ),
      ),
    );
  }
}
