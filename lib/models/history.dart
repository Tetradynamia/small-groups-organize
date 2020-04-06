import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:t3/models/group_member.dart';
import '../models/app_database.dart';
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
    );
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
    String id,
    List<List<GroupMember>> subGroups,
    String groupName,
    String note,
  ) async {
    // final url =
    //     'https://flutter-project-4ed4f.firebaseio.com/history/$userId.json?auth=$authToken';
    // final timeStamp = DateTime.now();

    // final response = await http.post(url,
    //     body: jsonEncode({
    //       'groupName': groupName,
    //       'note': note,
    //       'dateTime': timeStamp.toIso8601String(),
    //       'subGroups':
    //           subGroups.map((i) => i.map((k) => k.toJson()).toList()).toList()
    //     }));
    final timeStamp = DateTime.now();
    _history.insert(
      0,
      HistoryItem(
        id: UniqueKey().toString(),
        subGroups: subGroups,
        dateTime: timeStamp,
        groupName: groupName,
        note: note,
      ),
    );

    await _historyFolder.add(await _db, {
      'id': id,
      'dateTime': timeStamp.toIso8601String(),
      'groupName': groupName,
      'note': note,
      'subGroups': subGroups
          .map((subGroup) => subGroup.map((gm) => gm.toJson()).toList())
          .toList()
    });
    print('Student Inserted successfully !!');
    notifyListeners();
  }

  Future<void> removeFromHistory(String id) async {

  }

  Future<void> insertHistory(
    String id,
    List<List<GroupMember>> subGroups,
    String groupName,
    String note,
  ) async {
    final timeStamp = DateTime.now();

    AppDatabase.insert('history', {
      'id': UniqueKey().toString(),
      'groupName': groupName,
      'dateTime': timeStamp.toIso8601String(),
      'note': note,
      'smallGroups': jsonEncode({
        'subGroups':
            subGroups.map((i) => i.map((k) => k.toJson()).toList()).toList()
      }),
    });
  }

  Future<void> getHistory() async {

    final recordSnapshot = await _historyFolder.find(await _db);
    List<HistoryItem> loadedH;
    loadedH = recordSnapshot.map((snapshot) {
      print(snapshot.value);
      final historyEntry = HistoryItem.fromMap(snapshot.value);
      print(historyEntry);
      return historyEntry;
    }).toList();
    _history = loadedH;
    print(_history);
  }
}
