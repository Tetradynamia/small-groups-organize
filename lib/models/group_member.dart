import 'package:flutter/material.dart';

class GroupMember with ChangeNotifier {
  String memberId;
  String memberName;
  String groupName;
  bool isAbsent;

  GroupMember({
   @required this.memberId,
   @required this.memberName,
   @required this.groupName,
    this.isAbsent = false,
  });


void toggleIsAbsent() {
  isAbsent =! isAbsent;
}

}
