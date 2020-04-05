import 'package:sembast/sembast.dart';

import '../models/sembast_database.dart';
import '../models/groups.dart';

class GroupDao{
  static const String folderName = "Groups";
  final _groupFolder = intMapStoreFactory.store(folderName);


  Future<Database> get  _db  async => await SDatabase.instance.database;

   Future insertGroup(Group group) async{

    await  _groupFolder.add(await _db, group.toJson() );
    print('Student Inserted successfully !!');
  }

  Future updateGroup(Group group) async{
    final finder = Finder(filter: Filter.equals('groupId',group.groupId));
    await _groupFolder.update(await _db, group.toJson(),finder: finder);

  }


  Future delete(Group group) async{
    final finder = Finder(filter: Filter.byKey(group.groupId));
    await _groupFolder.delete(await _db, finder: finder);
  }

  Future<List<Group>> getAllGroups()async{
    final recordSnapshot = await _groupFolder.find(await _db);
    return recordSnapshot.map((snapshot){
      final group = Group.fromJson(snapshot.value);
      return group;
    }).toList();
  }


}