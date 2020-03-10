import 'package:flutter/material.dart';
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

  void addToHistory(
      String id, List<List<GroupMember>> subGroups, String groupName, String note,) {
    _history.putIfAbsent(
      id,
      () => HistoryItem(
        id: DateTime.now().toString(),
        subGroups: subGroups,
        dateTime: DateTime.now(),
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
