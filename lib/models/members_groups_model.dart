import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t3/models/http_exception.dart';

import '../models/group_member.dart';
import '../models/groups.dart';

class MembersGroupsModel with ChangeNotifier {
  List<Group> _groups = [
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
  List<GroupMember> _members = [
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

  Future<void> fetchAndSetGroupsMembers() async {
    const groupsUrl =
        'https://flutter-project-4ed4f.firebaseio.com/groups.json';
    const membersUrl =
        'https://flutter-project-4ed4f.firebaseio.com/members.json';

    try {
      final groupsResponse = await http.get(groupsUrl);
      final extratctedGroupsData =
          jsonDecode(groupsResponse.body) as Map<String, dynamic>;
      final List<Group> loadedGroups = [];
      extratctedGroupsData.forEach((groupId, groupData) {
        loadedGroups.add(Group(
          groupId: groupId,
          groupName: groupData['groupName'],
          groupDescription: groupData['groupDescription'],
        ));
      });

      final membersResponse = await http.get(membersUrl);
      final extractedMembersData =
          jsonDecode(membersResponse.body) as Map<String, dynamic>;
      final List<GroupMember> loadedMembers = [];
      if (extractedMembersData != null) {
        extractedMembersData.forEach((memberId, memberData) {
          loadedMembers.add(GroupMember(
              memberId: memberId,
              memberName: memberData['memberName'],
              groupName: memberData['groupName'],
              isAbsent: memberData['isAbsent']));
        });
        _groups = loadedGroups;
        _members = loadedMembers;
        notifyListeners();
      } else {
        return;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addGroup(Group group) async {
    const url = 'https://flutter-project-4ed4f.firebaseio.com/groups.json';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'groupName': group.groupName,
            'groupDescription': group.groupDescription,
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
          'https://flutter-project-4ed4f.firebaseio.com/groups/$id.json';
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

  Future<void> addMember(GroupMember member) async {
    const url = 'https://flutter-project-4ed4f.firebaseio.com/members.json';

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'memberName': member.memberName,
            'groupName': member.groupName,
            'isAbsent': member.isAbsent,
          },
        ),
      );

      final newMember = GroupMember(
          memberId: json.decode(response.body)['name'],
          memberName: member.memberName,
          groupName: member.groupName,
          isAbsent: false);
      _members.insert(0, newMember);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateMember(String id, GroupMember updatedMember) async {
    final groupIndex = _members.indexWhere((member) => member.memberId == id);
    if (groupIndex >= 0) {
      final url =
          'https://flutter-project-4ed4f.firebaseio.com/members/$id.json';
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
    } else {
      print('...');
    }
    notifyListeners();
  }

 Future <void> removeMember(String id) async {
    final url = 'https://flutter-project-4ed4f.firebaseio.com/members/$id.json';
    final existingMemberIndex =
        _members.indexWhere((member) => member.memberId == id);
    var existingMember = _members[existingMemberIndex];
    _members.removeAt(existingMemberIndex);
    notifyListeners();

 final response = await http.delete(url);
    if (response.statusCode >= 400){
      _members.insert(existingMemberIndex, existingMember);
      notifyListeners();
      throw HttpException('Could not delete member!');
    }
      existingMember = null;
    
      
    }
    
  
}
