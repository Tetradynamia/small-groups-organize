import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  

  @override
  void didChangeDependencies() {
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

  void _saveForm() {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedGroup.groupId != null) {
      Provider.of<MembersGroupsModel>(context, listen: false)
          .updateGroup(_editedGroup.groupId, _editedGroup);
      
    } else {
      Provider.of<MembersGroupsModel>(context, listen: false)
          .addGroup(_editedGroup);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(children: [
          TextFormField(
            initialValue: _initValues['name'],
            decoration: InputDecoration(labelText: 'Name:'),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_descriptionFocusNode);
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
                child: Text('Cance'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ])
        ]),
      ),
    );
  }
}
