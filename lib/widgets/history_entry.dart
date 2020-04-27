import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/edit_history_entry.dart';
import '../models/history.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          ListTile(
            key: ValueKey(widget.entry.id),
            title: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(widget.entry.dateTime)),
            subtitle:
                widget.entry.note == null ? Text('') : Text(widget.entry.note),
            trailing: Container(
              width: 150,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon:
                        Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                  ),
                  IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            title: const Text('Edit History Entry'),
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
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                title: const Text('Confirm delete'),
                                content: const Text(
                                    'Are you sure you want to delete this entry?'),
                                actions: <Widget>[
                                  FlatButton.icon(
                                      onPressed: () {
                                        historyData.removeFromHistory(
                                          widget.entry.id,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      label: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel',
                                        style: TextStyle(color: Colors.black)),
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
            Container(
              child: Column(
                children: <Widget>[
                  ...widget.entry.subGroups
                      .map((subGroup) => (Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      title: Text(member.memberName),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          )))
                      .toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
