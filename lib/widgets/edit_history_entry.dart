import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/group_member.dart';
import '../models/history.dart';

class EditHistoryEntry extends StatefulWidget {
  final String id;
  final List<List<GroupMember>> subGroups;
  final DateTime dateTime;
  final String groupName;
  final String note;

  EditHistoryEntry(
    this.id,
    this.subGroups,
    this.dateTime,
    this.groupName,
    this.note,
  );

  @override
  _EditHistoryEntryState createState() => _EditHistoryEntryState();
}

class _EditHistoryEntryState extends State<EditHistoryEntry> {
  final _form = GlobalKey<FormState>();

  var _editedEntry = HistoryItem(
    id: null,
    dateTime: null,
    groupName: '',
    subGroups: null,
    note: '',
  );
  var _initValues = {
    'note': '',
  };

  @override
  void initState() {
    if (widget.id != null) {
      _editedEntry = Provider.of<History>(context, listen: false)
          .history
          .firstWhere((item) => item.id == widget.id);

      _initValues = {
        'note': widget.note,
      };
    }
    super.initState();
  }

  void _saveForm() {
    _form.currentState.save();
    if (_editedEntry.id != null) {
      Provider.of<History>(context, listen: false).updateHistory(_editedEntry);
    } else {
      Provider.of<History>(context, listen: false).addToHistory(_editedEntry);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                initialValue: _initValues['note'],
                decoration: InputDecoration(labelText: 'Note:'),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  Navigator.of(context).pop();
                },
                onSaved: (value) {
                  _editedEntry = HistoryItem(
                    id: _editedEntry.id,
                    subGroups: widget.subGroups,
                    groupName: widget.groupName,
                    dateTime: widget.dateTime,
                    note: value,
                  );
                },
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                FlatButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.save),
                        Text('Save'),
                      ],
                    ),
                    onPressed: _saveForm),
                FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ])
            ],
          ),
        ),
      ),
    );
  }
}
