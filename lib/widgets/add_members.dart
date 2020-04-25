import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/group_member.dart';
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
    groupId: '',
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
            .members
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
            title: const Text('An error occured!'),
            content: const Text('Something went wrong!'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'))
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
        : Form(
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
                        groupId: widget.groupId);
                  },
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton.icon(
                          icon: const Icon(Icons.save, color: Colors.black),
                          label: const Text(
                            'Save',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: _saveForm),
                      FlatButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
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
