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

  Future<void> fetchAndSetHistory() async {
    final url = 'https://flutter-project-4ed4f.firebaseio.com/history/$userId.json?auth=$authToken';

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
    _history = loadedHistory;
    notifyListeners();
  }

  Future<void> addToHistory(
    String id,
    List<List<GroupMember>> subGroups,
    String groupName,
    String note,
  ) async {
    final url = 'https://flutter-project-4ed4f.firebaseio.com/history/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: jsonEncode({
          'groupName': groupName,
          'note': note,
          'dateTime': timeStamp.toIso8601String(),
          'subGroups':
              subGroups.map((i) => i.map((k) => k.toJson()).toList()).toList()
        }));

    _history.insert(
      0,
      HistoryItem(
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
    final url = 'https://flutter-project-4ed4f.firebaseio.com/history/$id?auth=$authToken';

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
  }

  notifyListeners();
}
