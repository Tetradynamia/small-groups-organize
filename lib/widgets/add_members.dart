import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/models/group_member.dart';

import '../models/members_groups_model.dart';

class EditMembers extends StatefulWidget {

  final String memberId;
  final String groupName;

  EditMembers(this.memberId, this.groupName);
  @override
  _EditMembersState createState() => _EditMembersState();
}

class _EditMembersState extends State<EditMembers> {
  final _form = GlobalKey<FormState>();
  var _editedMember = GroupMember(
    memberId: null,
    groupName: '',
    memberName: '',
  );
  var _initValues = {
    'name': '',
  };
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.memberId != null) {
        _editedMember = Provider.of<MembersGroupsModel>(context, listen: false)
            .findMemberById(widget.memberId);

        _initValues = {
          'name': _editedMember.memberName,
        };
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveForm() {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    if (widget.memberId != null){
    Provider.of<MembersGroupsModel>(context, listen: false)
        .updateMember(_editedMember.memberId ,_editedMember);
    }
else{
    Provider.of<MembersGroupsModel>(context, listen: false)
        .addMember(_editedMember);}

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(children: [
          TextFormField(
            autofocus: true,
            initialValue: _initValues['name'],
            decoration: InputDecoration(labelText: 'Name:'),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {Navigator.of(context).pop();},
            validator: (value) {
              if (value.isEmpty) {
                return 'Please provide a valid name';
              }
              return null;
            },
            onSaved: (value) {
              _editedMember = GroupMember(
                  memberId: _editedMember.memberId,
                  memberName: value,
                  groupName: widget.groupName);
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
        ]),
      ),
    );
  }
}
