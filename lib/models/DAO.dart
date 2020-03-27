import 'package:sembast/sembast.dart';

import '../models/groups.dart';
import '../models/app_database.dart';


class GroupDao {
  static const String folderName = "Groups";
  final _groupFolder = intMapStoreFactory.store(folderName);


  Future<Database> get  _db  async => await AppDatabase.instance.database;

  Future insertGroup(Group group) async{

    await  _groupFolder.add(await _db, group.toJson() );
    print('Student Inserted successfully !!');
  }

  Future<void> getAllGroups() async {
     List <Group> loadedG = [];
    final recordSnapshot = await _groupFolder.find(await _db);
    loadedG = recordSnapshot.map((snapshot){
        final student = Group.fromJson(snapshot.value);
      return student;
    }).toList();
      
    }
  }
