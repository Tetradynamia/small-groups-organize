import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/models/history.dart';
import 'package:intl/intl.dart';

class HistoryEntry extends StatefulWidget {
  final HistoryItem entry;
  final String avain;

  HistoryEntry(this.entry, this.avain);

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
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if (_expanded)
          Column(children: <Widget>[
            ...widget.entry.subGroups
                .map((subGroup) => (Card(
                      child: Column(
                        children: [    Card(
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: Text(
                              'In-group ${widget.entry.subGroups.indexOf(subGroup) + 1}:',
                              style: TextStyle(
                                fontSize: 16, color: Colors.white
                              ),
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
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete, color: Theme.of(context).errorColor,),
                  alignment: Alignment.topRight,
                  onPressed: () => historyData.removeFromHistory(widget.avain),
                ),
              ],
            )
          ]),
      ]),
    );
  }
}
