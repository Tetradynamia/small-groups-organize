import 'package:flutter/material.dart';

import '../screens/tabs_screen.dart';

class GroupItem extends StatelessWidget {
final String id;
final String name;
final String description;

GroupItem(this.id, this.name, this.description,);


  @override
  Widget build(BuildContext context) {


    return GridTile(
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(TabsScreen.routeName, arguments: name);
        },
        child: Container(height: 150, color: Colors.red, child: Text(name),)
      ),
      footer: GridTileBar(
        title: Text(description),
      ),
    );
  }
}
