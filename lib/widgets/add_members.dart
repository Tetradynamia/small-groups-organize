import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/models/group_member.dart';

import '../models/members_groups_model.dart';

class EditMembers extends StatefulWidget {
  final String memberId;
  final String groupId;

  EditMembers(this.memberId, this.groupId);
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
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.memberId != null) {
        _editedMember = Provider.of<MembersGroupsModel>(context, listen: false)
            .groups
            .firstWhere((group) => group.groupId == widget.groupId)
            .groupMembers
            .firstWhere((member) => member.memberId == widget.memberId);

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

  Future<void> _saveForm() async {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();

    if (widget.memberId != null) {
      Provider.of<MembersGroupsModel>(context, listen: false)
          .updateMember(_editedMember.memberId, _editedMember);
    } else {
      Provider.of<MembersGroupsModel>(context, listen: false)
          .addMember(_editedMember);
      print(widget.groupId);
    }

    setState(() {
      _isLoading = true;
    });
    if (widget.memberId != null) {
      await Provider.of<MembersGroupsModel>(context, listen: false)
          .updateMember(_editedMember.memberId, _editedMember);
    } else {
      try {
        await Provider.of<MembersGroupsModel>(context, listen: false)
            .addMember(_editedMember);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong!'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      initialValue: _initValues['name'],
                      decoration: InputDecoration(labelText: 'Name:'),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        Navigator.of(context).pop();
                      },
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
                            groupName: _editedMember.groupName);
                      },
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
