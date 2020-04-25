import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/group_member.dart';
import '../widgets/edit_history_entry.dart';
import '../widgets/shuffle_item.dart';
import '../models/members_groups_model.dart';
import '../models/divide_small_groups.dart';

class ShuffleScreen extends StatefulWidget {
  @override
  _ShuffleScreenState createState() => _ShuffleScreenState();
}

class _ShuffleScreenState extends State<ShuffleScreen> {
  final _form = GlobalKey<FormState>();
  var sizeController = TextEditingController();
  final _buttonFocusNode = FocusNode();
  int _radioValue = -1;
  var _expanded = true;
  
  var _isInit = true;

  // Variables to hold questions list and current question
  List<GroupMember> _availableMembers;
  List<List<GroupMember>> _currentInGroups;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final id = ModalRoute.of(context).settings.arguments as String;

    _availableMembers = Provider.of<MembersGroupsModel>(context, listen: false)
        .thisGroupAvailableMembers(id);
  }

  @override
  void dispose() {
    sizeController.dispose();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  _handleRadioValueChange(int value) {
    setState(() {
      sizeController.clear();
      _radioValue = value;
    });
  }

  _handleSmallGroups() {
    _isInit = false;
    switch (_radioValue) {
      case 0:
        if (sizeController.text.isNotEmpty) {
          setState(() {
            _currentInGroups =
                Provider.of<DivideSmallGroups>(context, listen: false)
                    .numberOfGroups(
                        int.parse(sizeController.text), _availableMembers);
          });
          Provider.of<DivideSmallGroups>(context, listen: false).storeLatest(
              ModalRoute.of(context).settings.arguments, _currentInGroups);
          _isInit = false;
          didChangeDependencies();
          _expanded = false;
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

          Provider.of<DivideSmallGroups>(context, listen: false).storeLatest(
              ModalRoute.of(context).settings.arguments, _currentInGroups);
          _isInit = false;
          didChangeDependencies();

          _expanded = false;
        } else {
          print('shit');
          return;
        }

        break;
    }
  }

  void _clear() {
    _currentInGroups = null;
    _radioValue = -1;
    didChangeDependencies();
    sizeController.clear();
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                dense: true,
                title: Text(
                  'Members present: ${_availableMembers.length}',
                  style: TextStyle(fontSize: 20),
                ),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
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
                padding: EdgeInsets.only(
                  left: 8,
                  right: 8,
                  
                ),
                height: MediaQuery.of(context).size.height * 0.36,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                             const Text('Choose either:'),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Radio(
                                        value: 0,
                                        groupValue: _radioValue,
                                        onChanged: _handleRadioValueChange),
                                   const Text('number of small groups'),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Radio(
                                        value: 1,
                                        groupValue: _radioValue,
                                        onChanged: _handleRadioValueChange),
                                   const Text('size of small groups'),
                                  ],
                                ),
                              ],
                            ),
                            Form(
                              key: _form,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Give an integer.',
                                  ),
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) {FocusScope.of(context)
                                          .requestFocus(_buttonFocusNode);},
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
                                  focusNode: _buttonFocusNode,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
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
                                    label: const Text('Assign small groups',
                                        style: TextStyle(color: Colors.white)),
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                  )
                                : RaisedButton.icon(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Theme.of(context).errorColor,
                                    onPressed: () {
                                      setState(() {
                                        _clear();
                                        Provider.of<DivideSmallGroups>(context,
                                                listen: false)
                                            .deleteLatest(
                                          ModalRoute.of(context)
                                              .settings
                                              .arguments,
                                        );
                                        _currentInGroups = null;
                                      });
                                    },
                                    label:const Text('Reset',
                                        style: TextStyle(color: Colors.white)),
                                    icon:const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_isInit || _currentInGroups != null)
              FutureBuilder(
                  future: Provider.of<DivideSmallGroups>(
                    context,
                  ).fetchLatest(ModalRoute.of(context).settings.arguments),
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (dataSnapshot.error != null) {
                      return const Center(child: const Text('An error occured!'));
                    } else if (Provider.of<DivideSmallGroups>(context,
                                listen: false)
                            .latest ==
                        null) {
                      return  Flexible(child: const Text('No small groups assigned!!'));
                    } else {
                      return Flexible(
                        child: ShuffleItem(
                            Provider.of<DivideSmallGroups>(context,
                                    listen: false)
                                .latest
                                .subGroups,
                            Provider.of<DivideSmallGroups>(
                              context,
                            ).latest.dateTime),
                      );
                    }
                  })
          ],
        ),
      ),
      floatingActionButton: IntrinsicWidth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FloatingActionButton.extended(
                heroTag: null,
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                   const Icon(Icons.save),
                   const Text('Save'),
                  ],
                ),
                onPressed: () {
                  if (Provider.of<DivideSmallGroups>(context, listen: false)
                          .latest ==
                      null) { return <void>[];
                  } else {
                    return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text('Want to save?'),
                              content: EditHistoryEntry(
                                null,
                                Provider.of<DivideSmallGroups>(context,
                                        listen: false)
                                    .latest
                                    .subGroups,
                                Provider.of<DivideSmallGroups>(context,
                                        listen: false)
                                    .latest
                                    .dateTime,
                                ModalRoute.of(context).settings.arguments,
                                null,
                              ),
                            ));
                  }
                }),
            SizedBox(height: 10),
            FloatingActionButton.extended(
              heroTag: null,
              backgroundColor: Theme.of(context).errorColor,
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                 const Icon(Icons.clear),
                 const Text('Discard'),
                ],
              ),
              onPressed: () {
                setState(() {
                  _clear();
                  _expanded = true;
                  Provider.of<DivideSmallGroups>(context, listen: false)
                      .deleteLatest(
                    ModalRoute.of(context).settings.arguments,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
