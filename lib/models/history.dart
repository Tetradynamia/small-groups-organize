import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';


import '../models/group_member.dart';
import '../models/sembast_database.dart';

class HistoryItem {
  final String id;
  final List<List<GroupMember>> subGroups;
  final DateTime dateTime;
  final String groupId;
  final String note;

  HistoryItem({
    @required this.id,
    @required this.subGroups,
    @required this.dateTime,
    @required this.groupId,
    this.note,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'dateTime': dateTime.toIso8601String(),
        'groupId': groupId,
        'note': note,
        'subGroups': subGroups
            .map((subGroup) => subGroup.map((gm) => gm.toJson()).toList())
            .toList()
      };

  static HistoryItem fromMap(Map<String, dynamic> map) {
    return HistoryItem(
        id: map['id'],
        dateTime: DateTime.parse(map['dateTime']),
        groupId: map['groupId'],
        subGroups: (map['subGroups'] as List<dynamic>)
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
      groupId: item.groupId,
      note: item.note,
    );

    _history.insert(
      0,
      newHistoryItem,
    );

    await _historyFolder.add(await _db, {
      'id': newHistoryItem.id,
      'dateTime': newHistoryItem.dateTime.toIso8601String(),
      'groupId': newHistoryItem.groupId,
      'note': newHistoryItem.note,
      'subGroups': newHistoryItem.subGroups
          .map((subGroup) => subGroup.map((gm) => gm.toJson()).toList())
          .toList()
    });

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

  Future<void> removeFromHistory(String id,) async {
    final existingIndex = _history.indexWhere((item) => item.id == id);
    final finder = Finder(filter: Filter.equals('id', id));

    await _historyFolder.delete(await _db, finder: finder);

    _history.removeAt(existingIndex);
    notifyListeners();
  }

  Future<void> removeGroupHistory(String groupId) async {
     List <HistoryItem> groupHistory = [];
    groupHistory.addAll(_history.where((entry) => entry.groupId == groupId));
    groupHistory.forEach((entry) {
      removeFromHistory(entry.id);
    });
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
