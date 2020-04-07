

import 'package:flutter/material.dart';
import 'package:t3/models/group_member.dart';


import 'package:sembast/sembast.dart';
import '../models/sembast_database.dart';

class HistoryItem {
  final String id;
  final List<List<GroupMember>> subGroups;
  final DateTime dateTime;
  final String groupName;
  final String note;

  HistoryItem({
    @required this.id,
    @required this.subGroups,
    @required this.dateTime,
    @required this.groupName,
    this.note,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'dateTime': dateTime.toIso8601String(),
        'groupName': groupName,
        'note': note,
        'subGroups': subGroups
            .map((subGroup) => subGroup.map((gm) => gm.toJson()).toList())
            .toList()
      };

  static HistoryItem fromMap(Map<String, dynamic> map) {
    return HistoryItem(
        id: map['id'],
        dateTime: DateTime.parse(map['dateTime']),
        groupName: map['groupName'],
        subGroups: (map['subGroups'] as List<dynamic>)
            .map((subGroup) => ((subGroup) as List<dynamic>)
                .map(
                  (member) => GroupMember(
                    memberName: member['memberName'],
                    memberId: member['memberId'],
                    groupName: member['groupName'],
                    isAbsent: member['isAbsent'],
                  ),
                )
                .toList())
            .toList()
            .toList(),
        note: map['note']);
  }
}

class History with ChangeNotifier {
  List<HistoryItem> _history = [];

  List<HistoryItem> get history {
    return [..._history];
  }

  int get itemCount {
    return _history.length;
  }

  static const String historyFolder = "History";
  final _historyFolder = intMapStoreFactory.store(historyFolder);

  Future<Database> get _db async => await SDatabase.instance.database;

  Future<void> addToHistory(
    HistoryItem item,
  ) async {
    final newHistoryItem = HistoryItem(
      id: UniqueKey().toString(),
      subGroups: item.subGroups,
      dateTime: item.dateTime,
      groupName: item.groupName,
      note: item.note,
    );

    _history.insert(
      0,
      newHistoryItem,
    );

    await _historyFolder.add(await _db, {
      'id': newHistoryItem.id,
      'dateTime': newHistoryItem.dateTime.toIso8601String(),
      'groupName': newHistoryItem.groupName,
      'note': newHistoryItem.note,
      'subGroups': newHistoryItem.subGroups
          .map((subGroup) => subGroup.map((gm) => gm.toJson()).toList())
          .toList()
    });
    print('Student Inserted successfully !!');
    notifyListeners();
  }

  Future<void> updateHistory(
    HistoryItem updatedItem,
  ) async {
    final itemIndex = _history.indexWhere((item) => item.id == updatedItem.id);

    if (itemIndex >= 0) {
      final finder = Finder(filter: Filter.equals('id', updatedItem.id));
      await _historyFolder.update(
          await _db,
          {
            'note': updatedItem.note,
          },
          finder: finder);
      _history[itemIndex] = updatedItem;
      notifyListeners();
    }
  }

  Future<void> removeFromHistory(String id) async { 
    final existingIndex =
        _history.indexWhere((item) => item.id == id);

    final finder = Finder(filter: Filter.equals('id', id));
    await _historyFolder.delete(await _db, finder: finder);

    _history.removeAt(existingIndex);
    notifyListeners();
  }

  Future<void> getHistory() async {
    final recordSnapshot = await _historyFolder.find(await _db);
    List<HistoryItem> loadedH;
    loadedH = recordSnapshot.map((snapshot) {
      final historyEntry = HistoryItem.fromMap(snapshot.value);
      return historyEntry;
    }).toList();
    _history = loadedH;
  }
}
