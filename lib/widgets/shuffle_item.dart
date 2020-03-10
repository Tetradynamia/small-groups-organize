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
                    color: Colors.red,
                    child: Column(
                      children: [
                        Text(
                          'In-group ${_currentInGroups.indexOf(subGroup) + 1}:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        ...subGroup.map(
                            (member) => (Card(child: Text(member.memberName))))
                      ],
                    ),
                  )))
              .toList(),
        ],
      ),
    );
  }
}
