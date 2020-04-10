import 'package:flutter/material.dart';

import '../models/group_member.dart';


class DivideSmallGroups with ChangeNotifier {

List<List<GroupMember>> numberOfGroups(int numberOfGroups, List<GroupMember> _availableMembers) {
    // Initialize an empty variable
    List<List<GroupMember>> members;

    // Check that there are still some questions left in the list
    if (_availableMembers.isNotEmpty) {
      // Shuffle the list
      _availableMembers.shuffle();
      List<List<GroupMember>> temp = [];
      // var numberOfGroups = 4;
      // Get size of groups
      var groupSize = (_availableMembers.length / numberOfGroups).round();
      if (groupSize * numberOfGroups > _availableMembers.length) {
        groupSize = groupSize - 1;
      }
// divide into groups
      for (var i = 0; i < numberOfGroups; i += 1) {
        if (_availableMembers.length >= groupSize) {
          temp.add(_availableMembers.sublist(
              _availableMembers.length - groupSize, _availableMembers.length));
          _availableMembers.removeRange(
              _availableMembers.length - groupSize, _availableMembers.length);
        }
      }
// divide reminder
      if (_availableMembers.length > 0) {
        for (var i = 0; i < _availableMembers.length; i++) {
          temp[i].add(_availableMembers[i]);
        }
      }
      members = temp;
    }
print('number');
return members;
}


 List<List<GroupMember>>  sizeOfGroups(int sizeOfGroups, List<GroupMember> _availableMembers) {
// Initialize an empty variable
    List<List<GroupMember>> smallGroups;

    // Shuffle the list
    _availableMembers.shuffle();
    List<List<GroupMember>> temp = [];
    // get number of groups
    var numberOfGroups = (_availableMembers.length / sizeOfGroups).round();
    print(numberOfGroups);
    print(numberOfGroups * sizeOfGroups);
    print(_availableMembers.length);
    if (numberOfGroups * sizeOfGroups < _availableMembers.length) {
      numberOfGroups = numberOfGroups + 1;
    }

    //divide into groups

    for (var i = 0; i <= numberOfGroups; i += 1) {
      if (_availableMembers.length >= sizeOfGroups) {
        temp.add(_availableMembers.sublist(
            _availableMembers.length - sizeOfGroups, _availableMembers.length));
        _availableMembers.removeRange(
            _availableMembers.length - sizeOfGroups, _availableMembers.length);
      }
    }
// handle the rest

    if (sizeOfGroups > 2 && _availableMembers.length == 1) {
      for (var i = 0; i < _availableMembers.length; i++) {
        temp[i].add(_availableMembers[i]);
      }
    }

    if (sizeOfGroups > 2 && _availableMembers.length == sizeOfGroups - 1) {
      temp.add(_availableMembers);
    }

    if (_availableMembers.length != 0) {
      print('OH SHIT ${_availableMembers.length}');
    }
    smallGroups = temp;
    print('size');
    return smallGroups;
  
  }








}