import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t3/models/group_member.dart';
import '../models/http_exception.dart';

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

  Future<void> fetchAndSetHistory() async {
    const url = 'https://flutter-project-4ed4f.firebaseio.com/history.json';

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
                .map((member) => GroupMember(
                      memberName: member['memberName'],
                      memberId: member['memberId'],
                      groupName: member['groupName'],
                    ))
                .toList())
            .toList(),
      ));
    });
    loadedHistory.forEach((item) {
      _history.putIfAbsent(
          item.id,
          () => HistoryItem(
                id: item.id,
                dateTime: item.dateTime,
                groupName: item.groupName,
                subGroups: item.subGroups,
              ));
    });
    notifyListeners();
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
          'subGroups':
              subGroups.map((i) => i.map((k) => k.toJson()).toList()).toList()
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

  Future<void> removeFromHistory(String id) async {
    final url = 'https://flutter-project-4ed4f.firebaseio.com/history/$id';
    var existingHistory = _history[id];
    _history.remove(id);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _history.putIfAbsent(
          id,
          () => HistoryItem(
                id: existingHistory.id,
                subGroups: existingHistory.subGroups,
                dateTime: existingHistory.dateTime,
                groupName: existingHistory.groupName,
                note: existingHistory.note,
              ));
      notifyListeners();
      throw HttpException('Could not delete member!');
    }
    existingHistory = null;
  }

  notifyListeners();
}
