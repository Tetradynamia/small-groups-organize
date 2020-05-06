import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            children: [
              ListTile(
                title: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Select Language'),
                  ],
                ),
              ),
              ListTile(
                title: const Text('English'),
                onTap: () => MyApp.setLocale(context, Locale('en', 'US')),
              ),
              ListTile(
                title: const Text('Suomi'),
                onTap: () => MyApp.setLocale(context, Locale('fi', 'FI')),
              ),
            ],
          )),
      drawer: MainDrawer(),
    );
  }
}
