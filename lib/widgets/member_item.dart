import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/models/group_member.dart';

import '../models/members_groups_model.dart';

class MemberItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<GroupMember>(
        builder: (ctx, member, _) => ListTile(
          leading: Checkbox(
            value: member.isAbsent,
            onChanged: (bool checked) {
              member.toggleIsAbsent();
              if (member.isAbsent) {
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    '${member.memberName} was marked as absent',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 1),
                ));
              }
            },
          ),
          title: Text(
            member.memberName,
            style:
                TextStyle(color: member.isAbsent ? Colors.grey : Colors.black),
          ),
        ),
      ),
    );
  }
}
