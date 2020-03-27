import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/widgets/add_members.dart';

import '../models/groups.dart';
import '../models/members_groups_model.dart';
import '../screens/edit_groups_screen.dart';

class ManageGroupsItem extends StatefulWidget {
  final Group group;
  ManageGroupsItem(this.group);

  @override
  _ManageGroupsItemState createState() => _ManageGroupsItemState();
}

class _ManageGroupsItemState extends State<ManageGroupsItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final groupData = Provider.of<MembersGroupsModel>(context)
        .members
        .where((member) => member.groupName == widget.group.groupName)
        .toList();
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${groupData.length}')),
            title: Text('${widget.group.groupName}'),
            subtitle: Text(widget.group.groupDescription),
            trailing: Container(
              width: 200,
              child: Row(
                children: [
                  IconButton(
                    icon:
                        Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: groupData.length > 0
                        ? () {
                            setState(
                              () {
                                _expanded = !_expanded;
                              },
                            );
                          }
                        : null,
                  ),
                  IconButton(
                      icon: Icon(Icons.person_add),
                      onPressed: () {
                        return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Add member'),
                            content: EditMembers(null, widget.group.groupName),
                          ),
                        );
                      }),
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Edit group'),
                            content: EditGroupsScreen(widget.group.groupId),
                          ),
                        );
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text('Confirm delete'),
                                  content: Text(
                                      'Are you sure you want to delete ${widget.group.groupName} and all its members?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () async {
                                        try {
                                          await Provider.of<MembersGroupsModel>(
                                                  context,
                                                  listen: false)
                                              .deleteGroup(
                                                  widget.group.groupId);
                                        } catch (error) {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Deleting failed!'),
                                            ),
                                          );
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Theme.of(context).errorColor,
                                          ),
                                          Text('Delete')
                                        ],
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    )
                                  ],
                                ));
                      })
                ],
              ),
            ),
          ),
        ),
        if (_expanded)
          Card(
            child: Container(
              height: 200,
              child: ListView.builder(
                itemBuilder: (ctx, index) => Card(
                  child: ListTile(
                    dense: true,
                    title: Text(groupData[index].memberName),
                    trailing: Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Edit member'),
                                    content: EditMembers(
                                        groupData[index].memberId,
                                        widget.group.groupName),
                                  ),
                                );
                              }),
                          IconButton(
                              icon: Icon(Icons.delete,
                                  color: Theme.of(context).errorColor),
                              onPressed: () {
                                return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                          title: Text('Confirm remove'),
                                          content: Text(
                                              'Are you sure you want to remove ${groupData[index].memberName}?'),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () async {
                                                try {
                                                  await Provider.of<
                                                              MembersGroupsModel>(
                                                          context,
                                                          listen: false)
                                                      .removeMember(
                                                          groupData[index]
                                                              .memberId);
                                                } catch (error) {
                                                  Scaffold.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Deleting failed!'),
                                                    ),
                                                  );
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Theme.of(context)
                                                        .errorColor,
                                                  ),
                                                  Text('Delete')
                                                ],
                                              ),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel'),
                                            )
                                          ],
                                        ));
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                itemCount: groupData.length,
              ),
            ),
          ),
      ],
    );
  }
}
