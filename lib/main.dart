import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/models/auth.dart';
import 'package:t3/models/history.dart';
import 'package:t3/screens/manage_groups_screen.dart';

import './models/members_groups_model.dart';
import './screens/tabs_screen.dart';
import './screens/group_overview.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(
          value: MembersGroupsModel(),
        ),
        ChangeNotifierProvider.value(
          value: History(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.isAuth ? GroupOverview() : AuthScreen(),
          routes: {
            TabsScreen.routeName: (ctx) => TabsScreen(),
            ManageGroupsScreen.routeName: (ctx) => ManageGroupsScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
