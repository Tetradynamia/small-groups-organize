import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t3/models/http_exception.dart';

import '../models/group_member.dart';
import '../models/groups.dart';

import '../models/app_database.dart';
import '../models/sembast_database.dart';
import 'package:sembast/sembast.dart';

enum Mode { CloudMode, LocalMode }

class MembersGroupsModel with ChangeNotifier {
  List<Group> _groups = [];
  List<GroupMember> _members = [];

  final String authToken;
  final String userId;
  Mode _mode = Mode.CloudMode;

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

  List<GroupMember> get availableMembers {
    return [..._members.where((member) => member.isAbsent == false)];
  }

  Group findGroupById(String id) {
    return _groups.firstWhere((group) => group.groupId == id);
  }

  GroupMember findMemberById(String id) {
    return _members.firstWhere((member) => member.memberId == id);
  }

  void switchMode(Mode value) {
    _mode = value;
    print(_mode);
  }

  Future<void> fetchAndSetGroupsMembers() async {
    print(_mode);

    switch (_mode) {
      case Mode.LocalMode:
        {
          // final loadedGroups = await AppDatabase.getData('groups');
          // _groups = loadedGroups
          //     .map(
          //       (item) => Group(
          //         groupId: item['groupId'],
          //         groupName: item['groupName'],
          //         groupDescription: item['groupDescription'],
          //       ),
          //     )
          //     .toList();

          // final loadedMembers = await AppDatabase.getData('members');
          // _members = loadedMembers
          //     .map(
          //       (item) => GroupMember(
          //         memberId: item['memberId'],
          //         memberName: item['memberName'],
          //         groupName: item['groupName'],
          //         isAbsent: false,
          //       ),
          //     )
          //     .toList();
          // notifyListeners();

          final groupRecordSnapshot = await _groupFolder.find(await _db);
          List<Group> loadedG = [];

          loadedG = groupRecordSnapshot.map((snapshot) {
            final group = Group.fromJson(snapshot.value);
            print(snapshot.value);
            return group;
          }).toList();

          _groups = loadedG;

          final memberRecordSnapshot = await _memberFolder.find(await _db);
          List<GroupMember> loadedM = [];

          final extracted = memberRecordSnapshot.map((snapshot) {
            final student = GroupMember.fromJson(snapshot.value);
            return student;
          }).toList();
          extracted.forEach((member) {
            loadedM.add(GroupMember(
              memberId: member.memberId,
              groupName: member.groupName,
              memberName: member.memberName,
              isAbsent: false,
            ));
          });
          _members = loadedM;
        }
        break;
      case Mode.CloudMode:
        {
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
        break;
    }
  }

  Future<void> addGroup(Group group) async {
    if (_mode == Mode.LocalMode) {
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
    } else {
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
  }

  Future<void> updateGroup(String id, Group updatedGroup) async {
    final groupIndex = _groups.indexWhere((group) => group.groupId == id);

    if (groupIndex >= 0) {
      if (_mode == Mode.LocalMode) {
        // AppDatabase.updateGoup(id, {
        //   'groupName': updatedGroup.groupName,
        //   'groupDescription': updatedGroup.groupDescription,
        // });

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
      } else {
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
      }
    } else {
      print('...');
    }
    notifyListeners();
  }

  Future<void> deleteGroup(String id, Group group) async {
    if (_mode == Mode.LocalMode) {
      var groupIndex = _groups.indexWhere((group) => group.groupId == id);
      // var name = _groups[groupIndex].groupName;
      // List<GroupMember> groupMembers = [];
      // groupMembers.addAll(_members.where((member) => member.groupName == name));
      // AppDatabase.delete('groups', 'groupId', id);
      // if (groupMembers.isNotEmpty) {
      //   groupMembers.forEach((member) {
      //     AppDatabase.delete('members', 'memberId', member.memberId);
      //   });

      final finder = Finder(filter: Filter.equals('groupId', id));
      await _groupFolder.delete(await _db, finder: finder);
      _groups.removeAt(groupIndex);
      notifyListeners();
    } else {
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
    }

    // _members.removeWhere((member) => member.groupName == name);
    // notifyListeners();
  }

  void toggleAbsent(String id, GroupMember member) {
    final taskIndex = _members.indexWhere((member) => member.memberId == id);
    if (taskIndex >= 0) {
      _members[taskIndex].toggleIsAbsent();
    } else {
      print(taskIndex);
      print(id);
    }
    notifyListeners();
  }

  Future<void> addMember(GroupMember member) async {
    if (_mode == Mode.LocalMode) {
      final newMember = GroupMember(
        memberId: UniqueKey().toString(),
        memberName: member.memberName,
        groupName: member.groupName,
        isAbsent: member.isAbsent,
      );

      // AppDatabase.insert('members', {
      //   'memberId': newMember.memberId,
      //   'groupName': newMember.groupName,
      //   'memberName': newMember.memberName,
      // });

      await _memberFolder.add(await _db, {
        'memberId': newMember.memberId,
        'memberName': newMember.memberName,
        'groupName': newMember.groupName,
      });

      _members.insert(0, newMember);
      notifyListeners();
    } else {
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
            },
          ),
        );

        final newMember = GroupMember(
          memberId: json.decode(response.body)['name'],
          memberName: member.memberName,
          groupName: member.groupName,
        );
        _members.insert(0, newMember);
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> removeMember(String id) async {
    if (_mode == Mode.LocalMode) {
      AppDatabase.delete('members', 'memberId', id);
      final existingMemberIndex =
          _members.indexWhere((member) => member.memberId == id);
      _members.removeAt(existingMemberIndex);
      notifyListeners();
    } else {
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
  }

  Future<void> updateMember(String id, GroupMember updatedMember) async {
    final groupIndex = _members.indexWhere((member) => member.memberId == id);
    if (groupIndex >= 0) {
      if (_mode == Mode.LocalMode) {
        AppDatabase.updateMember(
          id,
          {
            'memberName': updatedMember.memberName,
            'groupName': updatedMember.groupName,
          },
        );
        notifyListeners();
      } else {
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
  }

  static const String groupFolder = "Groups";
  final _groupFolder = intMapStoreFactory.store(groupFolder);

  static const String memberFolder = "Members";
  final _memberFolder = intMapStoreFactory.store(memberFolder);

  Future<Database> get _db async => await SDatabase.instance.database;
}
