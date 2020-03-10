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
                .map((i) => (Card(
                      color: Colors.red,
                      child: Column(
                        children: [
                          ...i.map((k) => (Card(child: Text(k.memberName)))),
                        ],
                      ),
                    )))
                .toList(),
            IconButton(
              icon: Icon(Icons.delete),
              alignment: Alignment.bottomRight,
              onPressed: () => historyData.removeFromHistory(widget.avain),
            )
          ]),
      ]),
    );
  }
}
