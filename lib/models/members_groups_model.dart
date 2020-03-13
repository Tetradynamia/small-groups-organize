import 'package:flutter/material.dart';

import '../models/group_member.dart';
import '../models/groups.dart';

class MembersGroupsModel with ChangeNotifier {
  final List<Group> _groups = [
    Group(
      groupId: 'g1',
      groupName: 'Kusipäät',
      groupDescription: 'desc',
      groupMembers: [
        GroupMember(
          memberId: 'm1',
          memberName: 'Pentti Ananas',
          groupName: 'Kusipäät',
        ),
        GroupMember(memberId: 'm2', memberName: '1', groupName: 'Kusipäät'),
        GroupMember(memberId: 'm3', memberName: '2', groupName: 'Kusipäät'),
        GroupMember(memberId: 'm4', memberName: '3', groupName: 'Kusipäät'),
        GroupMember(memberId: 'm5', memberName: '4', groupName: 'Kusipäät'),
        GroupMember(memberId: 'm6', memberName: '5', groupName: 'Kusipäät'),
        GroupMember(memberId: 'm7', memberName: '6', groupName: 'Kusipäät'),
        GroupMember(memberId: 'm8', memberName: '7', groupName: 'Kusipäät'),
        GroupMember(memberId: 'm9', memberName: '8', groupName: 'Mustikat'),
        GroupMember(memberId: 'm10', memberName: '9', groupName: 'Mustikat'),
      ],
    ),
    Group(
      groupId: 'g2',
      groupName: 'Mustikat',
      groupDescription: 'desc',
      groupMembers: [],
    ),
  ];
  // final List<GroupMember> _members = [
  //   GroupMember(
  //       memberId: 'm1', memberName: 'Pentti Ananas', groupName: 'Kusipäät'),
  //   GroupMember(
  //       memberId: 'm2', memberName: 'Pentti Urhola', groupName: 'Kusipäät'),
  //   GroupMember(memberId: 'm2', memberName: '1', groupName: 'Kusipäät'),
  //   GroupMember(memberId: 'm3', memberName: '2', groupName: 'Kusipäät'),
  //   GroupMember(memberId: 'm4', memberName: '3', groupName: 'Kusipäät'),
  //   GroupMember(memberId: 'm5', memberName: '4', groupName: 'Kusipäät'),
  //   GroupMember(memberId: 'm6', memberName: '5', groupName: 'Kusipäät'),
  //   GroupMember(memberId: 'm7', memberName: '6', groupName: 'Kusipäät'),
  //   GroupMember(memberId: 'm8', memberName: '7', groupName: 'Kusipäät'),
  //   GroupMember(memberId: 'm9', memberName: '8', groupName: 'Mustikat'),
  //   GroupMember(memberId: 'm10', memberName: '9', groupName: 'Mustikat'),
  // ];

  List<Group> get groups {
    return [..._groups];
  }

  // List<GroupMember> get members {
  //   return [..._members];
  // }

  // List<GroupMember> get shuffleMembers {
  //   return [..._members];
  // }

  // List<GroupMember> get availableMembers {
  //   return [..._members.where((member) => member.isAbsent == false)];
  // }

  Group findGroupById(String id) {
    return _groups.firstWhere((group) => group.groupId == id);
  }

  // GroupMember findMemberById(String id) {
  //   return _members.firstWhere((member) => member.memberId == id);
  // }

  void addGroup(Group group) {
    final newGroup = Group(
        groupId: DateTime.now().toString(),
        groupName: group.groupName,
        groupDescription: group.groupDescription,
        groupMembers: []);
    _groups.add(newGroup);
    print(newGroup.groupId);
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
    _groups.removeWhere((group) => group.groupId == id);
    notifyListeners();
  }

  void toggleAbsent(String groupId, GroupMember member) {
    final group = _groups.firstWhere((group) => group.groupId == groupId);
    final memberIndex = group.groupMembers.indexOf(member);
    group.groupMembers[memberIndex].toggleIsAbsent();
    notifyListeners();
  }

  void addMember(String groupId, GroupMember member) {
    final newMember = GroupMember(
        memberId: DateTime.now().toString(),
        memberName: member.memberName,
        groupName: member.groupName);
    _groups
        .firstWhere((group) => group.groupId == groupId)
        .groupMembers
        .insert(0, newMember);
    notifyListeners();
  }

  void updateMember(
      String groupId, String memberId, GroupMember updatedMember) {
    final memberIndex = _groups
        .firstWhere((group) => group.groupId == groupId)
        .groupMembers
        .indexWhere((member) => member.memberId == memberId);
    if (memberIndex >= 0) {
      _groups
          .firstWhere((group) => group.groupId == groupId)
          .groupMembers[memberIndex] = updatedMember;
    } else {
      print('...');
    }
    notifyListeners();
  }

  void removeMember(String groupId, String memberId) {
   final group = _groups.firstWhere((group) => group.groupId == groupId);
    group.groupMembers.removeWhere((member) => member.memberId == memberId);
    notifyListeners();
  }


}