import 'package:flutter/material.dart';

class Group with ChangeNotifier {
  String groupId;
  String groupName;
  String groupDescription = '';

  Group({
  @required  this.groupId,
   @required this.groupName,
    this.groupDescription,
  });
}

List <Group> _groups = [];

List <Group> get groups {
  return [..._groups];
}