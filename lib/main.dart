import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t3/models/history.dart';
import 'package:t3/screens/group_overview.dart';
import 'package:t3/screens/manage_groups_screen.dart';

import './models/members_groups_model.dart';
import './screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MembersGroupsModel()),
        ChangeNotifierProvider.value(value: History()),
      ],
      child: MaterialApp(
        title: 'MyShop',
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
