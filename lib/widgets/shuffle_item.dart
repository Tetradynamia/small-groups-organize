import 'package:flutter/material.dart';
import 'package:t3/models/group_member.dart';

class ShuffleItem extends StatelessWidget {
  final List<List<GroupMember>> _currentInGroups;
  ShuffleItem(this._currentInGroups);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          ..._currentInGroups
              .map((subGroup) => (Card(
                    child: Column(
                      children: [
                        Card(
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: Text(
                              'Small group ${_currentInGroups.indexOf(subGroup) + 1}:',
                              style: TextStyle(
                                fontSize: 16, color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        ...subGroup.map((member) => (Card(
                            child: ListTile(title: Text(member.memberName)))))
                      ],
                    ),
                  )))
              .toList(),
        ],
      ),
    );
  }
}
