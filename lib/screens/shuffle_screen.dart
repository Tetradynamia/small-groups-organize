import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/models/group_member.dart';
import 'package:t3/widgets/edit_history_entry.dart';
import 'package:t3/widgets/shuffle_item.dart';

import '../models/members_groups_model.dart';
import '../models/divide_small_groups.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context).settings.arguments;

    _availableMembers = Provider.of<MembersGroupsModel>(context, listen: false)
        .thisGroupAvailableMembers(id);
  }

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
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
          setState(() {
            _currentInGroups =
                Provider.of<DivideSmallGroups>(context, listen: false)
                    .numberOfGroups(
                        int.parse(sizeController.text), _availableMembers);
          });
          didChangeDependencies();
          sizeController.clear();
        } else {
          print('shit');
          return;
        }
        break;
      case 1:
        if (sizeController.text.isNotEmpty) {
          setState(() {
            _currentInGroups =
                Provider.of<DivideSmallGroups>(context, listen: false)
                    .sizeOfGroups(
                        int.parse(sizeController.text), _availableMembers);
          });
          didChangeDependencies();
          sizeController.clear();
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
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        dense: true,
                        title: Text(
                          'Members present: ${_availableMembers.length}',
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: IconButton(
                          icon: Icon(_expanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                        ),
                      ),
                    ),
                    if (_expanded)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Give an integer.',
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
                                      if (_radioValue == 1 &&
                                          int.parse(value) >
                                              (_availableMembers.length) /
                                                  2.round()) {
                                        return 'Please enter a number smaller than ${(_availableMembers.length) / 2.floor().toInt()})';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              _availableMembers.isNotEmpty &&
                                      _currentInGroups == null
                                  ? RaisedButton.icon(
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        final isValid =
                                            _form.currentState.validate();
                                        if (!isValid) {
                                          return;
                                        } else {
                                          _handleSmallGroups();
                                        }
                                      },
                                      label: Text('Assign small groups',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      icon: Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                    )
                                  : RaisedButton.icon(
                                      color: Theme.of(context).errorColor,
                                      onPressed: () {
                                        setState(() {
                                          _currentInGroups = null;
                                          didChangeDependencies();
                                          sizeController.clear();
                                        });
                                      },
                                      label: Text('Reset',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      icon: Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // if (_availableMembers.isNotEmpty && _currentInGroups == null)
            //   Text('Assign new small groups'),
            if (_availableMembers.isNotEmpty && _currentInGroups != null)
              Flexible(child: ShuffleItem(_currentInGroups))
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: _currentInGroups != null ? true : false,
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FloatingActionButton.extended(
                  heroTag: null,
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
                              content: EditHistoryEntry(
                                null,
                                _currentInGroups,
                                DateTime.now(),
                                ModalRoute.of(context).settings.arguments,
                                null,
                              ),
                            ));
                  }),
              SizedBox(height: 10),
              FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Theme.of(context).errorColor,
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.clear),
                    Text('Discard'),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    _currentInGroups = null;
                    didChangeDependencies();
                    sizeController.clear();
                    _expanded = true;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
