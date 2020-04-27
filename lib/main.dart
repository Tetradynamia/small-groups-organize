import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './models/history.dart';
import './screens/group_overview.dart';
import './screens/manage_groups_screen.dart';
import './models/members_groups_model.dart';
import './screens/tabs_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MembersGroupsModel()),
        ChangeNotifierProvider.value(value: History()),
      ],
      child: MaterialApp(
        title: 'small groups - ORGANIZE!',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GroupOverview(),
        routes: {
          TabsScreen.routeName: (ctx) => TabsScreen(),
          ManageGroupsScreen.routeName: (ctx) => ManageGroupsScreen(),
          GroupOverview.routeName: (ctx) => GroupOverview(),
        },
      ),
    );
  }
}
