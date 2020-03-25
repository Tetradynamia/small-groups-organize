import 'package:flutter/material.dart';
import 'package:t3/models/group_member.dart';

class Group with ChangeNotifier {
  String groupId;
  String groupName;
  String groupDescription = '';
  List <GroupMember> groupMembers = [];

  Group({
  @required  this.groupId,
   @required this.groupName,
    this.groupDescription,
    this.groupMembers,
  });
}

List <Group> _groups = [];

List <Group> get groups {
  return [..._groups];
}