import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/widgets/member_item.dart';

import '../models/members_groups_model.dart';

class GroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gName = ModalRoute.of(context).settings.arguments;
    final memberData = Provider.of<MembersGroupsModel>(context);
    final thisGroupMembers = memberData.members
        .where((member) => member.groupName == gName)
        .toList();
    final thisGroupAvailableMembers = memberData.availableMembers
        .where((member) => member.groupName == gName)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Card(
                              child: ListTile(
                    title: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('${thisGroupAvailableMembers.length} / ${thisGroupMembers.length} members present'),
                  ],
                )),
              ),
              Divider(),
              Row(
                children: [
                  Text('Is absent?'),
                ],
              )
            ]),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: thisGroupMembers.length,
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: thisGroupMembers[index],
                child: MemberItem(
                  member: thisGroupMembers[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
