import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/members_groups_model.dart';
import '../models/group_member.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    final gName = ModalRoute.of(context).settings.arguments;

    final thisGroupMembers =
        Provider.of<MembersGroupsModel>(context, listen: false)
            .members
            .where((member) => member.groupName == gName)
            .toList();

    final availableMembers = Provider.of<MembersGroupsModel>(context)
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
                        '${availableMembers.length} / ${thisGroupMembers.length} members present'),
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
                child: Card(
                  child: Consumer<GroupMember>(
                    builder: (ctx, member, _) => ListTile(
                      leading: Checkbox(
                        value: member.isAbsent,
                        onChanged: (bool checked) {
                          setState(() {
                            member.toggleIsAbsent();
                          });
                          
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
                        style: TextStyle(
                            color:
                                member.isAbsent ? Colors.grey : Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
