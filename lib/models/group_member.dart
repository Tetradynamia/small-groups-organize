import 'package:flutter/material.dart';

class GroupMember with ChangeNotifier {
  String memberId;
  String memberName;
  String groupName;
  bool isAbsent = false;

  GroupMember({
   @required this.memberId,
   @required this.memberName,
   @required this.groupName,
    this.isAbsent,
  });


void toggleIsAbsent() {
  isAbsent =! isAbsent;
}

Map toJson() => {
  'memberId': memberId,
  'memberName': memberName,
  'groupName': groupName,
};

}
