import 'package:flutter/material.dart';



class GroupMember with ChangeNotifier {
  final String memberId;
  final String memberName;
  final String groupId;
  bool isAbsent;

  GroupMember({
    @required this.memberId,
    @required this.memberName,
    @required this.groupId,
    this.isAbsent = false,
  });

  void toggleIsAbsent() {
    isAbsent = !isAbsent;

    notifyListeners();

    
  }

  Map toJson() => {
        'memberId': memberId,
        'memberName': memberName,
        'groupId': groupId,
        'isAbsent': isAbsent,
      };

  GroupMember.fromJson(Map<String, dynamic> json)
      : memberId = json['memberId'],
        memberName = json['memberName'],
        groupId = json['groupId'],
        isAbsent = json['isAbsent'];

     
  
}
