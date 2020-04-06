import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/widgets/member_item.dart';

import '../models/members_groups_model.dart';

class GroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gName = ModalRoute.of(context).settings.arguments;

    final thisGroupMembers = Provider.of<MembersGroupsModel>(context)
        .members
        .where((member) => member.groupName == gName)
        .toList();
    final thisGroupAvailableMembers =
        thisGroupMembers.where((member) => member.isAbsent == false).toList();

    final avail = Provider.of<MembersGroupsModel>(context)
        .availableMembers
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
                    title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        '${avail.length} / ${thisGroupMembers.length} members present'),
                  ],
                )),
              ),
              const Divider(),
              Row(
                children: [
                  const Text('Is absent?'),
                ],
              )
            ]),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: thisGroupMembers.length,
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: thisGroupMembers[index],
                child: MemberItem(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
