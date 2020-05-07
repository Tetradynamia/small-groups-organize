import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/group_member.dart';
import '../localizations/localization_constants.dart';

class ShuffleItem extends StatelessWidget {
  final List<List<GroupMember>> _currentInGroups;
  final DateTime dateTime;
  ShuffleItem(this._currentInGroups, this.dateTime);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            title: Text(
                '${getTranslation(context, 'assigned')} ${DateFormat('dd/MM/yyyy HH:mm').format(dateTime)}'),
          ),
          ..._currentInGroups
              .map((subGroup) => (Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: Text(
                              '${getTranslation(context, 'small_group')} ${_currentInGroups.indexOf(subGroup) + 1}:',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        ...subGroup.map((member) => (Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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
