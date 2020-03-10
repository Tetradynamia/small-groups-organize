import 'package:flutter/material.dart';
import 'package:t3/widgets/drawer.dart';

import '../widgets/groups_grid.dart';

class GroupOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groups'),
      ),
      body: GroupsGrid(),
      drawer: MainDrawer(),
    );
  }
}