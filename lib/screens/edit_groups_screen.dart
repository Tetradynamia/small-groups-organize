import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/groups.dart';
import '../models/members_groups_model.dart';
import '../localizations/localization_constants.dart';

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
    } else {
      await Provider.of<MembersGroupsModel>(context, listen: false).addGroup(
        Group(
          groupId: _editedGroup.groupId,
          groupName: _editedGroup.groupName,
          groupDescription: _editedGroup.groupDescription,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Form(
          key: _form,
          child: SingleChildScrollView(
        child: Column(children: [
          TextFormField(
            initialValue: _initValues['name'],
            decoration: InputDecoration(labelText: getTranslation(context, 'edit_name_label')),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
        FocusScope.of(context)
            .requestFocus(_descriptionFocusNode);
            },
            validator: (value) {
        if (value.isEmpty) {
          return getTranslation(context, 'name_validator');
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
            decoration: InputDecoration(labelText: getTranslation(context, 'description_label')),
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
                 Text(getTranslation(context, 'save')),
                ],
              ),
              onPressed: _saveForm),
          FlatButton(
              child: Text(getTranslation(context, 'Cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ])
        ]),
          ),
        );
  }
}
