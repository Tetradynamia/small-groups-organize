import 'package:flutter/material.dart';

import '../models/group_member.dart';
import '../models/groups.dart';
import '../models/sembast_database.dart';
import 'package:sembast/sembast.dart';

enum Mode { CloudMode, LocalMode }

class MembersGroupsModel with ChangeNotifier {
  List<Group> _groups = [];
  List<GroupMember> _members = [];

  List<Group> get groups {
    return [..._groups];
  }

  List<GroupMember> get members {
    return [..._members];
  }

  List<GroupMember> get availableMembers {
    return [..._members.where((member) => member.isAbsent == false)];
  }

  List<GroupMember> thisGroupMembers(String id) {
    return _members.where((member) => member.groupId == id).toList();
  }

  List<GroupMember> thisGroupAvailableMembers(String id) {
    return thisGroupMembers(id)
        .where((member) => member.isAbsent == false)
        .toList();
  }

  Group findGroupById(String id) {
    return _groups.firstWhere((group) => group.groupId == id);
  }

  GroupMember findMemberById(String id) {
    return _members.firstWhere((member) => member.memberId == id);
  }

  Future<void> fetchAndSetGroupsMembers() async {
    {
      final groupRecordSnapshot = await _groupFolder.find(await _db);
      List<Group> loadedG = [];

      loadedG = groupRecordSnapshot.map((snapshot) {
        final group = Group.fromJson(snapshot.value);
        return group;
      }).toList();

      _groups = loadedG;

      final memberRecordSnapshot = await _memberFolder.find(await _db);
      List<GroupMember> loadedM = [];

      final extracted = memberRecordSnapshot.map((snapshot) {
        final member = GroupMember.fromJson(snapshot.value);
        return member;
      }).toList();
      extracted.forEach((member) {
        loadedM.add(GroupMember(
          memberId: member.memberId,
          groupId: member.groupId,
          memberName: member.memberName,
          isAbsent: false,
        ));
      });
      _members = loadedM;
    }
  }

  Future<void> addGroup(Group group) async {
    final newGroup = Group(
      groupId: UniqueKey().toString(),
      groupName: group.groupName,
      groupDescription: group.groupDescription,
    );

    await _groupFolder.add(await _db, {
      'groupId': newGroup.groupId,
      'groupDescription': group.groupDescription,
      'groupName': group.groupName,
    });
    print('Student Inserted successfully !!');

    _groups.add(newGroup);
    notifyListeners();
  }

  Future<void> updateGroup(String id, Group updatedGroup) async {
    final groupIndex = _groups.indexWhere((group) => group.groupId == id);
    print(groupIndex);

    if (groupIndex >= 0) {
      final finder = Finder(filter: Filter.equals('groupId', id));
      await _groupFolder.update(
          await _db,
          {
            'groupDescription': updatedGroup.groupDescription,
            'groupName': updatedGroup.groupName,
          },
          finder: finder);
      _groups[groupIndex] = updatedGroup;
      notifyListeners();
    }
  }

  Future<void> deleteGroup(String id, Group group) async {
    var groupIndex = _groups.indexWhere((group) => group.groupId == id);

    var groupId = group.groupId;
    List<GroupMember> groupMembers = [];
    groupMembers.addAll(_members.where((member) => member.groupId == groupId));

    final finder = Finder(filter: Filter.equals('groupId', id));
    await _groupFolder.delete(await _db, finder: finder);

    if (groupMembers.isNotEmpty) {
      groupMembers.forEach((member) {
        removeMember(member.memberId);
      });
    }

    _groups.removeAt(groupIndex);

    notifyListeners();
  }

  Future<void> addMember(GroupMember member) async {
    final newMember = GroupMember(
      memberId: UniqueKey().toString(),
      memberName: member.memberName,
      groupId: member.groupId,
      isAbsent: member.isAbsent,
    );

    await _memberFolder.add(await _db, {
      'memberId': newMember.memberId,
      'memberName': newMember.memberName,
      'groupId': newMember.groupId,
    });

    _members.insert(0, newMember);
    notifyListeners();
  }

  Future<void> removeMember(String id) async {
    final existingMemberIndex =
        _members.indexWhere((member) => member.memberId == id);

    final finder = Finder(filter: Filter.equals('memberId', id));
    await _memberFolder.delete(await _db, finder: finder);

    _members.removeAt(existingMemberIndex);
    notifyListeners();
  }

  Future<void> updateMember(String id, GroupMember updatedMember) async {
    final groupIndex = _members.indexWhere((group) => group.memberId == id);
    print(groupIndex);

    if (groupIndex >= 0) {
      final finder =
          Finder(filter: Filter.equals('memberId', updatedMember.memberId));
      await _memberFolder.update(
          await _db,
          {
            'memberName': updatedMember.memberName,
          },
          finder: finder);
      _members[groupIndex] = updatedMember;
      notifyListeners();
    }
  }

  static const String groupFolder = "Groups";
  final _groupFolder = intMapStoreFactory.store(groupFolder);

  static const String memberFolder = "Members";
  final _memberFolder = intMapStoreFactory.store(memberFolder);

  Future<Database> get _db async => await SDatabase.instance.database;
}
