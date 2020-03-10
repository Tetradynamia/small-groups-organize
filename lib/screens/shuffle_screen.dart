import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/models/group_member.dart';
import 'package:t3/widgets/shuffle_item.dart';

import '../models/members_groups_model.dart';
import '../models/history.dart';

class ShuffleScreen extends StatefulWidget {
  @override
  _ShuffleScreenState createState() => _ShuffleScreenState();
}

class _ShuffleScreenState extends State<ShuffleScreen> {
  final _form = GlobalKey<FormState>();
  var sizeController = TextEditingController();
  int _radioValue = -1;
  var _expanded = true;

  // Variables to hold questions list and current question
  List<GroupMember> _availableMembers;
  List<List<GroupMember>> _currentInGroups;
  String gName;
  String note;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gName = ModalRoute.of(context).settings.arguments;
    final memberData = Provider.of<MembersGroupsModel>(context, listen: false);
    _availableMembers = memberData.availableMembers
        .where((member) => member.groupName == gName)
        .toList();
  }

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
  }

  void _numberOfGroups(int numberOfGroups) {
    // Initialize an empty variable
    List<List<GroupMember>> question;

    // Check that there are still some questions left in the list
    if (_availableMembers.isNotEmpty) {
      // Shuffle the list
      _availableMembers.shuffle();
      List<List<GroupMember>> temp = [];
      // var numberOfGroups = 4;
      // Get size of groups
      var groupSize = (_availableMembers.length / numberOfGroups).round();
      if(groupSize*numberOfGroups > _availableMembers.length){
        groupSize = groupSize - 1;
      }
// divide into groups
      for (var i = 0; i < numberOfGroups; i += 1) {
        if (_availableMembers.length >= groupSize) {
          temp.add(_availableMembers.sublist(
              _availableMembers.length - groupSize, _availableMembers.length));
          _availableMembers.removeRange(
              _availableMembers.length - groupSize, _availableMembers.length);
        }
      }
// divide reminder
      if (_availableMembers.length > 0) {
        for (var i = 0; i < _availableMembers.length; i++) {
          temp[i].add(_availableMembers[i]);
        }
      }
      question = temp;
    }

    setState(() {
      // call set state to update the view
      _currentInGroups = question;
      _expanded = false;
    });
  }

  void _sizeOfGroups(int sizeOfGroups) {
// Initialize an empty variable
    List<List<GroupMember>> question;

    // Shuffle the list
    _availableMembers.shuffle();
    List<List<GroupMember>> temp = [];
    // get number of groups
    var numberOfGroups = (_availableMembers.length / sizeOfGroups).round();

    //divide into groups

    for (var i = 0; i < numberOfGroups; i += 1) {
      if (_availableMembers.length >= sizeOfGroups) {
        temp.add(_availableMembers.sublist(
            _availableMembers.length - sizeOfGroups, _availableMembers.length));
        _availableMembers.removeRange(
            _availableMembers.length - sizeOfGroups, _availableMembers.length);
      }
    }
// handle the rest

    if (sizeOfGroups > 2 && _availableMembers.length == sizeOfGroups - 1) {
      temp.add(_availableMembers);
    }
    question = temp;
    setState(() {
      // call set state to update the view
      _currentInGroups = question;
      _expanded = false;
    });
  }

  _handleRadioValueChange(int value) {
    setState(() {
      sizeController.clear();
      _radioValue = value;
    });
  }

  _handleSmallGroups() {
    switch (_radioValue) {
      case 0:
        if (sizeController.text.isNotEmpty) {
          _numberOfGroups(int.parse(sizeController.text));
          sizeController.clear();
          didChangeDependencies();
        } else {
          print('shit');
          return;
        }
        break;
      case 1:
        if (sizeController.text.isNotEmpty) {
          _sizeOfGroups(int.parse(sizeController.text));
          sizeController.clear();
          didChangeDependencies();
        } else {
          print('shit');
          return;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Card(
                  child: Card(
                    child: ListTile(
                      dense: true,
                      title: Text(
                        'Members present: ${_availableMembers.length}',
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                if (_expanded)
                  Container(
                    child: Card(
                      child: Column(
                        children: [
                          Text('Choose either:'),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio(
                                      value: 0,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange),
                                  Text('number of small groups'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Radio(
                                      value: 1,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange),
                                  Text('size of small groups'),
                                ],
                              ),
                            ],
                          ),
                          Form(
                            key: _form,
                            autovalidate: true,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Set the size of small groups',
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              controller: sizeController,
                              validator: (value) {
                                if (_radioValue == -1) {
                                  return 'Please select the mode of operation';
                                }
                                if (value.isEmpty) {
                                  return 'Please enter an integer value ';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter an integer value';
                                }
                                if (int.parse(value) <= 1) {
                                  return 'Please enter a number greater than 1';
                                }
                                if (_radioValue == 0 &&
                                    int.parse(value) >=
                                        _availableMembers.length) {
                                  return 'Please enter a number smaller than ${_availableMembers.length})';
                                }

                                return null;
                              },
                            ),
                          ),
                          RaisedButton.icon(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              final isValid = _form.currentState.validate();
                              if (!isValid) {
                                return;
                              } else {
                                _handleSmallGroups();
                              }
                            },
                            label: Text('Assign small groups',
                                style: TextStyle(color: Colors.white)),
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            if (_availableMembers.isNotEmpty && _currentInGroups == null)
              Text('Assign new small groups'),
            if (_availableMembers.isNotEmpty && _currentInGroups != null)
              ShuffleItem(_currentInGroups)
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: _currentInGroups != null ? true : false,
        child: FloatingActionButton.extended(
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.save),
                Text('Save'),
              ],
            ),
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Want to save?'),
                        content: Text('Are you sure?'),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                                Provider.of<History>(context, listen: false)
                                    .addToHistory(
                                        DateTime.now().toString(),
                                        _currentInGroups,
                                        ModalRoute.of(context)
                                            .settings
                                            .arguments,
                                        note);
                              },
                              child: Text('Yes')),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text('No'))
                        ],
                      ));
            }),
      ),
    );
  }
}
