import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t3/models/group_member.dart';
import '../models/http_exception.dart';
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
  final String authToken;
  final String userId;

  History(this.authToken, this.userId, this._history);

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

  Future<void> fetchAndSetHistory() async {
    final url =
        'https://flutter-project-4ed4f.firebaseio.com/history/$userId.json?auth=$authToken';

    final response = await http.get(url);
    final List<HistoryItem> loadedHistory = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }

    extractedData.forEach((id, historyData) {
      loadedHistory.add(HistoryItem(
        id: id,
        dateTime: DateTime.parse(historyData['dateTime']),
        groupName: historyData['groupName'],
        note: historyData['note'],
        subGroups: (historyData['subGroups'] as List<dynamic>)
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
            .toList(),
      ));
    });
    _history = loadedHistory;
    notifyListeners();
  }

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
    final url =
        'https://flutter-project-4ed4f.firebaseio.com/history/$id?auth=$authToken';

    var existingIndex = _history.indexWhere((entry) => entry.id == id);
    var existingHistory = _history[existingIndex];
    _history.remove(id);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _history.insert(existingIndex, existingHistory);
      notifyListeners();
      throw HttpException('Could not delete member!');
    }
    existingHistory = null;
    notifyListeners();
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
    //   final loadedHistory = await AppDatabase.getData('history');

    //   print(loadedHistory);

    //   _history = loadedHistory
    //       .map((item) => HistoryItem(
    //             id: item['id'],
    //             subGroups: (item['smallGroups']['subGroups'] as List<dynamic>)
    //                 .map((subGroup) => ((subGroup) as List<dynamic>)
    //                     .map((member) => GroupMember(
    //                           memberName: member['memberName'],
    //                           memberId: member['memberId'],
    //                           groupName: member['groupName'],
    //                         ))
    //                     .toList())
    //                 .toList(),
    //             dateTime: DateTime.parse(item['dateTime']),
    //             groupName: item['groupName'],
    //           ))
    //       .toList();

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
