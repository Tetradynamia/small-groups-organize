import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t3/models/http_exception.dart';

import '../models/group_member.dart';
import '../models/groups.dart';

import 'package:sembast/sembast.dart';

import '../models/app_database.dart';

enum Mode { CloudMode, LocalMode }

class MembersGroupsModel with ChangeNotifier {
  List<Group> _groups = [];
  List<GroupMember> _members = [];

  final String authToken;
  final String userId;
  Mode _mode;

  MembersGroupsModel(this.authToken, this.userId, this._groups, this._members);

  Mode get mode {
    return _mode;
  }

  List<Group> get groups {
    return [..._groups];
  }

  List<GroupMember> get members {
    return [..._members];
  }

  // List<GroupMember> get shuffleMembers {
  //   return [..._members];
  // }

  List<GroupMember> get availableMembers {
    return [..._members.where((member) => member.isAbsent == false)];
  }

  Group findGroupById(String id) {
    return _groups.firstWhere((group) => group.groupId == id);
  }

  GroupMember findMemberById(String id) {
    return _members.firstWhere((member) => member.memberId == id);
  }

  void switchMode(value) {
    _mode = value;
  }

  Future<void> fetchAndSetGroupsMembers() async {
    final groupsUrl =
        'https://flutter-project-4ed4f.firebaseio.com/groups.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    final membersUrl =
        'https://flutter-project-4ed4f.firebaseio.com/members.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';

    try {
      final groupsResponse = await http.get(groupsUrl);
      final membersResponse = await http.get(membersUrl);

      final extratctedGroupsData =
          jsonDecode(groupsResponse.body) as Map<String, dynamic>;
      final extractedMembersData =
          jsonDecode(membersResponse.body) as Map<String, dynamic>;

      if (extractedMembersData == null || extratctedGroupsData == null) {
        _groups = [];
        _members = [];
        notifyListeners();
        return;
      }

      final List<Group> loadedGroups = [];
      extratctedGroupsData.forEach((groupId, groupData) {
        loadedGroups.add(Group(
          groupId: groupId,
          groupName: groupData['groupName'],
          groupDescription: groupData['groupDescription'],
        ));
      });

      // final membersResponse = await http.get(membersUrl);
      // final extractedMembersData =
      //     jsonDecode(membersResponse.body) as Map<String, dynamic>;
      final List<GroupMember> loadedMembers = [];

      extractedMembersData.forEach((memberId, memberData) {
        loadedMembers.add(GroupMember(
          memberId: memberId,
          memberName: memberData['memberName'],
          groupName: memberData['groupName'],
        ));
      });
      _groups = loadedGroups;
      _members = loadedMembers;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addGroup(Group group) async {
    final url =
        'https://flutter-project-4ed4f.firebaseio.com/groups.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'groupName': group.groupName,
            'groupDescription': group.groupDescription,
            'creatorId': userId,
          },
        ),
      );

      final newGroup = Group(
        groupId: json.decode(response.body)['name'],
        groupName: group.groupName,
        groupDescription: group.groupDescription,
      );
      _groups.add(newGroup);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateGroup(String id, Group updatedGroup) async {
    final groupIndex = _groups.indexWhere((group) => group.groupId == id);

    if (groupIndex >= 0) {
      final url =
          'https://flutter-project-4ed4f.firebaseio.com/groups/$id.json?auth=$authToken';
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              'groupName': updatedGroup.groupName,
              'groupDescription': updatedGroup.groupDescription,
            },
          ),
        );
        _groups[groupIndex] = updatedGroup;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
    notifyListeners();
  }

  Future<void> deleteGroup(String id) async {
    final url =
        'https://flutter-project-4ed4f.firebaseio.com/groups/$id.json?auth=$authToken';
    var groupIndex = _groups.indexWhere((group) => group.groupId == id);
    var existingGroup = _groups[groupIndex];
    var name = _groups[groupIndex].groupName;
    List<GroupMember> groupMembers = [];
    groupMembers.addAll(_members.where((member) => member.groupName == name));
    _groups.removeAt(groupIndex);

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _groups.insert(groupIndex, existingGroup);
      notifyListeners();
      throw HttpException('Could not delete group!');
    } else if (groupMembers.isNotEmpty) {
      groupMembers.forEach((member) {
        removeMember(member.memberId);
      });
    } else {
      notifyListeners();
      return;
    }

    // _members.removeWhere((member) => member.groupName == name);
    // notifyListeners();
  }

  void toggleAbsent(GroupMember member) {
    final memberIndex = _members.indexOf(member);
    _members[memberIndex].toggleIsAbsent();
    notifyListeners();
  }

  Future<void> addMember(GroupMember member) async {
    final url =
        'https://flutter-project-4ed4f.firebaseio.com/members.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'memberName': member.memberName,
            'groupName': member.groupName,
            'creatorId': userId,
            'isAbsent': member.isAbsent,
          },
        ),
      );

      final newMember = GroupMember(
        memberId: json.decode(response.body)['name'],
        memberName: member.memberName,
        groupName: member.groupName,
        isAbsent: member.isAbsent,
      );
      _members.insert(0, newMember);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeMember(String id) async {
    final url =
        'https://flutter-project-4ed4f.firebaseio.com/members/$id.json?auth=$authToken';
    final existingMemberIndex =
        _members.indexWhere((member) => member.memberId == id);
    var existingMember = _members[existingMemberIndex];
    _members.removeAt(existingMemberIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _members.insert(existingMemberIndex, existingMember);
      notifyListeners();
      throw HttpException('Could not delete member!');
    }
    existingMember = null;
  }

  Future<void> updateMember(String id, GroupMember updatedMember) async {
    final groupIndex = _members.indexWhere((member) => member.memberId == id);
    if (groupIndex >= 0) {
      final url =
          'https://flutter-project-4ed4f.firebaseio.com/members/$id.json?auth=$authToken';
      try {
        await http.patch(
          url,
          body: jsonEncode(
            {
              'memberName': updatedMember.memberName,
              'groupName': updatedMember.groupName,
            },
          ),
        );
        _members[groupIndex] = updatedMember;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  static const String folderName = "Students";
  final _groupFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insertGroup(Group student) async {
    await _groupFolder.add(
      await _db, 
      {
        'groupName': student.groupName,
        'groupDescription': student.groupDescription,
        'groupId': student.groupId,
      },
    );
    print('Student Inserted successfully !!');
  }

  Future<void> getAllGroups() async {
     List<Group> loadedG = [];
    final recordSnapshot = await _groupFolder.find(await _db);
     loadedG = recordSnapshot.map((snapshot){
        final group = Group.fromJson(snapshot.value);
      return group;
    }).toList();
    _groups = loadedG;
  }
}
