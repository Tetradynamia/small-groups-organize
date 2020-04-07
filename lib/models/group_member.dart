import 'package:flutter/material.dart';



class GroupMember with ChangeNotifier {
  final String memberId;
  final String memberName;
  final String groupName;
  bool isAbsent;

  GroupMember({
    @required this.memberId,
    @required this.memberName,
    @required this.groupName,
    this.isAbsent = false,
  });

  void toggleIsAbsent() {
    isAbsent = !isAbsent;

    notifyListeners();

    
  }

  Map toJson() => {
        'memberId': memberId,
        'memberName': memberName,
        'groupName': groupName,
        'isAbsent': isAbsent,
      };

  GroupMember.fromJson(Map<String, dynamic> json)
      : memberId = json['memberId'],
        memberName = json['memberName'],
        groupName = json['groupName'];

     
  
}
