import 'package:flutter/material.dart';

import '../screens/manage_groups_screen.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'You have not added any groups yet! Tap the button below to add some!', textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              
            ),
          ),
          RaisedButton(
            child: Text('Go to Manage Groups'),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageGroupsScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
