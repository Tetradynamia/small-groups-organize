import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/models/group_member.dart';

import '../models/groups.dart';
import '../models/members_groups_model.dart';

class EditGroupsScreen extends StatefulWidget {
  static const routeName = '/edit-groups';

  final String groupId;
  EditGroupsScreen(this.groupId);
  @override
  _EditGroupsScreenState createState() => _EditGroupsScreenState();
}

class _EditGroupsScreenState extends State<EditGroupsScreen> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedGroup = Group(
    groupId: null,
    groupName: '',
    groupDescription: '',
  );
  var _initValues = {
    'name': '',
    'description': '',
  };
  var _isInit = true;

  String _oldName;
  var _isLoading = false;

  @override
  didChangeDependencies() {
    if (_isInit) {
      if (widget.groupId != null) {
        _editedGroup = Provider.of<MembersGroupsModel>(context, listen: false)
            .findGroupById(widget.groupId);

        _initValues = {
          'name': _editedGroup.groupName,
          'description': _editedGroup.groupDescription,
        };
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
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

    if (_editedGroup.groupId != null) {
      await Provider.of<MembersGroupsModel>(context, listen: false)
          .updateGroup(_editedGroup.groupId, _editedGroup);

      if (_editedGroup.groupName != _oldName) {
        List _helperList = [];
        Provider.of<MembersGroupsModel>(context, listen: false)
            .members
            .where((member) => member.groupName == _oldName)
            .forEach((member) => _helperList.add(member.memberId));
        print(_helperList);
        _helperList.forEach((id) async {
          await Provider.of<MembersGroupsModel>(context, listen: false)
              .updateMember(
                  id,
                  GroupMember(
                      memberId: id,
                      memberName: Provider.of<MembersGroupsModel>(context,
                              listen: false)
                          .findMemberById(id)
                          .memberName,
                      groupName: _editedGroup.groupName));
        });
      }
    } else {
      try {
        await Provider.of<MembersGroupsModel>(context, listen: false)
            .addGroup(_editedGroup);
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
                  child: const Text('Okay'))
            ],
          ),
        );
      } // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
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
                child: Column(children: [
                  TextFormField(
                    initialValue: _initValues['name'],
                    decoration: InputDecoration(labelText: 'Name:'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a valid name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedGroup = Group(
                          groupId: _editedGroup.groupId,
                          groupName: value,
                          groupDescription: _editedGroup.groupDescription);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration: InputDecoration(labelText: 'Description:'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    onSaved: (value) {
                      _editedGroup = Group(
                          groupId: _editedGroup.groupId,
                          groupName: _editedGroup.groupName,
                          groupDescription: value);
                    },
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                            child: Row(
                              children: <Widget>[
                                const Icon(Icons.save),
                                const Text('Save'),
                              ],
                            ),
                            onPressed: _saveForm),
                        FlatButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ])
                ]),
              ),
            ),
          );
  }
}
