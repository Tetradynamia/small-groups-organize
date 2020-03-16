import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t3/models/group_member.dart';

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
}

class History with ChangeNotifier {
  Map<String, HistoryItem> _history = {};

  Map<String, HistoryItem> get history {
    return {..._history};
  }

  int get itemCount {
    return _history.length;
  }

  Future<void> addToHistory(
    String id,
    List<List<GroupMember>> subGroups,
    String groupName,
    String note,
  ) async {
    const url = 'https://flutter-project-4ed4f.firebaseio.com/history.json';
    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: jsonEncode({
          'groupName': groupName,
          'note': note,
          'dateTime': timeStamp.toIso8601String(),
          'subGroups': subGroups.map((i) => i.map((k) =>k.toJson()).toList()).toList()
              
        }));

    _history.putIfAbsent(
      id,
      () => HistoryItem(
        id: json.decode(response.body)['name'],
        subGroups: subGroups,
        dateTime: timeStamp,
        groupName: groupName,
        note: note,
      ),
    );
    notifyListeners();
  }

  void removeFromHistory(String id) {
    _history.remove(id);
    print(_history.length);
    notifyListeners();
  }
}
