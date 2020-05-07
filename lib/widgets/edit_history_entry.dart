import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/localizations/localization_constants.dart';

import '../models/group_member.dart';
import '../models/history.dart';

class EditHistoryEntry extends StatefulWidget {
  final String id;
  final List<List<GroupMember>> subGroups;
  final DateTime dateTime;
  final String groupId;
  final String note;

  EditHistoryEntry(
    this.id,
    this.subGroups,
    this.dateTime,
    this.groupId,
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
    groupId: '',
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
    return Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              initialValue: _initValues['note'],
              decoration: InputDecoration(labelText: getTranslation(context, 'note')),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                Navigator.of(context).pop();
              },
              onSaved: (value) {
                _editedEntry = HistoryItem(
                  id: _editedEntry.id,
                  subGroups: widget.subGroups,
                  groupId: widget.groupId,
                  dateTime: widget.dateTime,
                  note: value,
                );
              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              FlatButton.icon(
                  icon: const Icon(Icons.save),
                  label:  Text(getTranslation(context, 'save')),
                  onPressed: () {
                    _saveForm();
                  }),
              FlatButton(
                  child:  Text(getTranslation(context, 'cancel')),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ])
          ],
        ),
      ),
    );
  }
}
