import 'package:flutter/material.dart';

import '../screens/group_screen.dart';
import '../screens/history_screen.dart';
import '../screens/shuffle_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;

  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {"page": GroupScreen(), "title": ''},
      {"page": ShuffleScreen(), "title": "Shuffle"},
      {"page": HistoryScreen(), "title": "Shuffle"},
    ];
    super.initState();
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
        title: Text('${ModalRoute.of(context).settings.arguments} '),
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
