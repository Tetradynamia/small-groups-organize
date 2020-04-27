import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import '../models/group_member.dart';
import '../models/sembast_database.dart';

class DivideSmallGroups with ChangeNotifier {
  LatestItem _latest;

  LatestItem get latest {
    return _latest;
  }

  List<List<GroupMember>> numberOfGroups(
      int numberOfGroups, List<GroupMember> _availableMembers) {
    // Initialize an empty variable
    List<List<GroupMember>> members;

    // Check that there are still some questions left in the list
    if (_availableMembers.isNotEmpty) {
      // Shuffle the list
      _availableMembers.shuffle();
      List<List<GroupMember>> temp = [];
      // var numberOfGroups = 4;
      // Get size of groups
      var groupSize = (_availableMembers.length / numberOfGroups).round();
      if (groupSize * numberOfGroups > _availableMembers.length) {
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
      members = temp;
    }
    return members;
  }

  List<List<GroupMember>> sizeOfGroups(
      int sizeOfGroups, List<GroupMember> _availableMembers) {
// Initialize an empty variable
    List<List<GroupMember>> smallGroups;

    // Shuffle the list
    _availableMembers.shuffle();
    List<List<GroupMember>> temp = [];
    // get number of groups
    var numberOfGroups = (_availableMembers.length / sizeOfGroups).round();
    print(numberOfGroups);
    print(numberOfGroups * sizeOfGroups);
    print(_availableMembers.length);
    if (numberOfGroups * sizeOfGroups < _availableMembers.length) {
      numberOfGroups = numberOfGroups + 1;
    }

    //divide into groups

    for (var i = 0; i <= numberOfGroups; i += 1) {
      if (_availableMembers.length >= sizeOfGroups) {
        temp.add(_availableMembers.sublist(
            _availableMembers.length - sizeOfGroups, _availableMembers.length));
        _availableMembers.removeRange(
            _availableMembers.length - sizeOfGroups, _availableMembers.length);
      }
    }
// handle the rest

    if (sizeOfGroups > 2 && _availableMembers.length == 1) {
      for (var i = 0; i < _availableMembers.length; i++) {
        temp[i].add(_availableMembers[i]);
      }
    }

    if (sizeOfGroups > 2 && _availableMembers.length == sizeOfGroups - 1) {
      temp.add(_availableMembers);
    }

    smallGroups = temp;
    return smallGroups;
  }

  static const String latestFolder = "Latest";
  final _latestFolder = intMapStoreFactory.store(latestFolder);

  Future<Database> get _db async => await SDatabase.instance.database;

  Future<void> storeLatest(
    String groupId,
    List<List<GroupMember>> smallGroups,
  ) async {
    if (smallGroups == null) {
      return;
    }
    final timeStamp = DateTime.now();

    _latest = LatestItem(
      groupId: groupId,
      dateTime: timeStamp,
      subGroups: smallGroups,
    );
    notifyListeners();
    await _latestFolder.add(await _db, {
      'groupId': groupId,
      'dateTime': timeStamp.toIso8601String(),
      'subGroups': smallGroups
          .map((subGroup) => subGroup.map((gm) => gm.toJson()).toList())
          .toList()
    });
    notifyListeners();
  }

  Future<void> fetchLatest(String id) async {
    final finder = Finder(filter: Filter.equals('groupId', id));
    final recordSnapshot = await _latestFolder.find(await _db, finder: finder);

    final ll = recordSnapshot.map((snapshot) {
      final last = LatestItem.fromJson(snapshot.value);
      return last;
    }).toList();
    if (ll.isEmpty) {
      _latest = null;
      return;
    }
    _latest = ll.last;
  }

  Future<void> deleteLatest(String id) async {
    final filter = Filter.and([ Filter.equals('groupId', id),
        Filter.lessThan('dateTime', DateTime.now().toIso8601String())]);
    var finder = Finder(filter: filter);
    await _latestFolder.delete(await _db, finder: finder);
  }
}

class LatestItem {
  final DateTime dateTime;
  final String groupId;
  final List<List<GroupMember>> subGroups;

  LatestItem({
    @required this.dateTime,
    @required this.groupId,
    @required this.subGroups,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'dateTime': dateTime.toIso8601String(),
        'groupId': groupId,
        'subGroups': subGroups
            .map((subGroup) => subGroup.map((gm) => gm.toJson()).toList())
            .toList()
      };

  static LatestItem fromJson(Map<String, dynamic> json) {
    return LatestItem(
      dateTime: DateTime.parse(json['dateTime']),
      groupId: json['groupId'],
      subGroups: (json['subGroups'] as List<dynamic>)
          .map((subGroup) => ((subGroup) as List<dynamic>)
              .map(
                (member) => GroupMember(
                  memberName: member['memberName'],
                  memberId: member['memberId'],
                  groupId: member['groupId'],
                  isAbsent: member['isAbsent'],
                ),
              )
              .toList())
          .toList()
          .toList(),
    );
  }
}
