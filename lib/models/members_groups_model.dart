import 'package:flutter/material.dart';

import '../models/group_member.dart';
import '../models/groups.dart';

class MembersGroupsModel with ChangeNotifier {
  final List<Group> _groups = [
    Group(
      groupId: 'g1',
      groupName: 'Kusipäät',
      groupDescription: 'desc',
    ),
    Group(
      groupId: 'g2',
      groupName: 'Mustikat',
      groupDescription: 'desc',
    ),
  ];
  final List<GroupMember> _members = [
    GroupMember(
        memberId: 'm1', memberName: 'Pentti Ananas', groupName: 'Kusipäät'),
    GroupMember(
        memberId: 'm21', memberName: 'Pentti Urhola', groupName: 'Kusipäät'),
    GroupMember(memberId: 'm2', memberName: '1', groupName: 'Kusipäät'),
    GroupMember(memberId: 'm3', memberName: '2', groupName: 'Kusipäät'),
    GroupMember(memberId: 'm4', memberName: '3', groupName: 'Kusipäät'),
    GroupMember(memberId: 'm5', memberName: '4', groupName: 'Kusipäät'),
    GroupMember(memberId: 'm6', memberName: '5', groupName: 'Kusipäät'),
    GroupMember(memberId: 'm7', memberName: '6', groupName: 'Kusipäät'),
    GroupMember(memberId: 'm8', memberName: '7', groupName: 'Kusipäät'),
    GroupMember(memberId: 'm9', memberName: '8', groupName: 'Mustikat'),
    GroupMember(memberId: 'm10', memberName: '9', groupName: 'Mustikat'),
  ];

  List<Group> get groups {
    return [..._groups];
  }

  List<GroupMember> get members {
    return [..._members];
  }

  List<GroupMember> get shuffleMembers {
    return [..._members];
  }

  List<GroupMember> get availableMembers {
    return [..._members.where((member) => member.isAbsent == false)];
  }

  Group findGroupById(String id) {
    return _groups.firstWhere((group) => group.groupId == id);
  }

  GroupMember findMemberById(String id) {
    return _members.firstWhere((member) => member.memberId == id);
  }

  void addGroup(Group group) {
    final newGroup = Group(
        groupId: DateTime.now().toString(),
        groupName: group.groupName,
        groupDescription: group.groupDescription);
    _groups.add(newGroup);
    notifyListeners();
  }

  void updateGroup(String id, Group updatedGroup) {
    final groupIndex = _groups.indexWhere((group) => group.groupId == id);
    if (groupIndex >= 0) {
      _groups[groupIndex] = updatedGroup;
    } else {
      print('...');
    }
    notifyListeners();
  }

  void deleteGroup(String id) {
    var groupIndex = _groups.indexWhere((group) => group.groupId == id);
    var name = _groups[groupIndex].groupName;
    _groups.removeWhere((group) => group.groupId == id);

    _members.removeWhere((member) => member.groupName == name);
    notifyListeners();
  }

  void toggleAbsent(GroupMember member) {
    final memberIndex = _members.indexOf(member);
    _members[memberIndex].toggleIsAbsent();
    notifyListeners();
  }

  void addMember(GroupMember member) {
    final newMember = GroupMember(
        memberId: DateTime.now().toString(),
        memberName: member.memberName,
        groupName: member.groupName);
    _members.insert(0, newMember);
    notifyListeners();
  }

  void updateMember(String id, GroupMember updatedMember) {
    final groupIndex = _members.indexWhere((member) => member.memberId == id);
    if (groupIndex >= 0) {
      _members[groupIndex] = updatedMember;
    } else {
      print('...');
    }
    notifyListeners();
  }

  void removeMember (String id) {
    
    _members.removeWhere((member) => member.memberId == id);
  }

  List mebersShuffle() {
    List<GroupMember> shuff = _members;
    shuff.shuffle();
    List f = [];
    var numberOfGroups = 4;
    var groupSize = (shuff.length / numberOfGroups).round();

    for (var i = 0; i < numberOfGroups; i += 1) {
      if (shuff.length >= groupSize) {
        f.add(shuff.sublist(shuff.length - groupSize, shuff.length));
        shuff.removeRange(shuff.length - groupSize, shuff.length);
      }
    }

    if (shuff.length > 0) {
      for (var i = 0; i < shuff.length; i++) {
        f[i].add(shuff[i]);
      }
    }

    notifyListeners();
    return f;
  }
}
