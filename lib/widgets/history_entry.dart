import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/models/history.dart';
import 'package:intl/intl.dart';

import '../widgets/edit_history_entry.dart';

class HistoryEntry extends StatefulWidget {
  final HistoryItem entry;

  HistoryEntry(this.entry);

  @override
  _HistoryEntryState createState() => _HistoryEntryState();
}

class _HistoryEntryState extends State<HistoryEntry> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final historyData = Provider.of<History>(context);
    return Card(
      child: Column(children: [
        ListTile(
          key: ValueKey(widget.entry.id),
          title: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.entry.dateTime)),
          subtitle:
              widget.entry.note == null ? Text('') : Text(widget.entry.note),
          trailing: Container(
            width: 150,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Edit History Entry'),
                          content: EditHistoryEntry(
                            widget.entry.id,
                            widget.entry.subGroups,
                            widget.entry.dateTime,
                            widget.entry.groupId,
                            widget.entry.note,
                          ),
                        ),
                      );
                    }),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () {
                    return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text('Confirm delete'),
                              content: Text('Are you sure you want to delete?'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    historyData
                                        .removeFromHistory(widget.entry.id);
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
                  },
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Column(children: <Widget>[
            ...widget.entry.subGroups
                .map((subGroup) => (Card(
                      child: Column(
                        children: [
                          Card(
                            color: Theme.of(context).primaryColor,
                            child: ListTile(
                              title: Text(
                                'Small group ${widget.entry.subGroups.indexOf(subGroup) + 1}:',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          ...subGroup.map(
                            (member) => (Card(
                              child: ListTile(
                                title: Text(member.memberName),
                              ),
                            )),
                          ),
                        ],
                      ),
                    )))
                .toList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[],
            )
          ]),
      ]),
    );
  }
}
