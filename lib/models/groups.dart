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


  Map toJson() => {
  'groupId': groupId,
  'groupDescription': groupDescription,
  'groupName': groupName,
};

 factory Group.fromJson(Map<String, dynamic> json) => Group(
    groupId: json['groupId'],
    groupName: json['groupName'],
    groupDescription: json['groupDescription']
  );
}


