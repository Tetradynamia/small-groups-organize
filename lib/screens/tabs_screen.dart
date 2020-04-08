import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/group_screen.dart';
import '../screens/history_screen.dart';
import '../screens/shuffle_screen.dart';
import '../models/members_groups_model.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String _groupName;
  bool _isInit = true;
  List<Map<String, Object>> _pages;

  int _selectedPageIndex = 1;

  @override
  void initState() {
    _pages = [
      {"page": GroupScreen(), "title": ''},
      {"page": ShuffleScreen(), "title": "Shuffle"},
      {"page": HistoryScreen(), "title": "Shuffle"},
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
    _groupName = Provider.of<MembersGroupsModel>(context, listen: false)
        .findGroupById(ModalRoute.of(context).settings.arguments)
        .groupName;}
        _isInit = false;
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_groupName),
      ),
      body: _pages[_selectedPageIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.red,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.group),
            title: Text("Group"),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.assignment),
            title: Text("Assign small groups"),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.archive),
            title: Text("Archive"),
          )
        ],
      ),
    );
  }
}
