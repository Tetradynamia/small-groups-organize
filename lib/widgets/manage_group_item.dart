import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../widgets/add_members.dart';
import '../models/groups.dart';
import '../models/members_groups_model.dart';
import '../screens/edit_groups_screen.dart';
import '../models/history.dart';

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
        .thisGroupMembers(widget.group.groupId);
    return Column(
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: CircleAvatar(child: Text('${groupData.length}')),
            title: Text('${widget.group.groupName}'),
            subtitle: Text(widget.group.groupDescription),
            trailing: Container(
              width: 100,
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
                  PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    icon: Icon(Icons.settings),
                    onSelected: (selection) {
                      switch (selection) {
                        case 1:
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title: const Text('Add member'),
                              content: EditMembers(null, widget.group.groupId),
                            ),
                          );
                          break;

                        case 2:
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title: const Text('Edit group'),
                              content: EditGroupsScreen(widget.group.groupId),
                            ),
                          );
                          break;

                        case 3:
                          return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    title: const Text('Confirm delete'),
                                    content: Text(
                                        'Are you sure you want to delete ${widget.group.groupName}, all its members and saved small groups?'),
                                    actions: <Widget>[
                                      FlatButton.icon(
                                        onPressed: () async {
                                          try {
                                            await Provider.of<History>(context,
                                                    listen: false)
                                                .removeGroupHistory(
                                                    widget.group.groupId);
                                            await Provider.of<
                                                        MembersGroupsModel>(
                                                    context,
                                                    listen: false)
                                                .deleteGroup(
                                                    widget.group.groupId,
                                                    widget.group);
                                          } catch (error) {
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                content:
                                                  const  Text('Deleting failed!'),
                                              ),
                                            );
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        label: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      )
                                    ],
                                  ));

                          break;
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                          const  Icon(Icons.person_add),
                          const  Text(
                              'Add members',
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: <Widget>[
                           const Icon(Icons.edit),
                           const Text('Edit group'),
                          ],
                        ),
                      ),
                       PopupMenuItem(
                        value: 3,
                        child:  Row(
                          children: <Widget>[
                           const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            const Text('Remove group'),
                          ],
                        ),
                      )
                    ],
                  ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(groupData[index].memberName),
                    trailing: Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    title: const Text('Edit member'),
                                    content: EditMembers(
                                        groupData[index].memberId,
                                        widget.group.groupId),
                                  ),
                                );
                              }),
                          IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          title: const Text('Confirm remove'),
                                          content: Text(
                                              'Are you sure you want to remove ${groupData[index].memberName}?'),
                                          actions: <Widget>[
                                            FlatButton.icon(
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
                                                      content: const Text(
                                                          'Deleting failed!'),
                                                    ),
                                                  );
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              label: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
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
