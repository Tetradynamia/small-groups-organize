import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localizations/localization_constants.dart';
import '../widgets/drawer.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  _getLanguageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslation(context, 'settings')),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            children: [
              Card(
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(getTranslation(context, 'language')),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Text('🇺🇸', style: TextStyle(fontSize: 20)),
                  title: const Text('English'),
                  onTap: () async {
                    if (_getLanguageCode(context) != 'en') {
                      var prefs = await SharedPreferences.getInstance();
                      await prefs.setString('languageCode', 'en');
                      await prefs.setString('countryCode', 'US');
                    }
                    MyApp.setLocale(context, Locale('en', 'US'));
                  },
                ),
              ),
              const Divider(),
              Card(
                child: ListTile(
                  leading: const Text(
                    '🇫🇮',
                    style: TextStyle(fontSize: 20),
                  ),
                  title: const Text('Suomi'),
                  onTap: () async {
                    if (_getLanguageCode(context) != 'fi') {
                      var prefs = await SharedPreferences.getInstance();
                      await prefs.setString('languageCode', 'fi');
                      await prefs.setString('countryCode', 'FI');
                    }
                    MyApp.setLocale(context, Locale('fi', 'FI'));
                  },
                ),
              ),
            ],
          )),
      drawer: MainDrawer(),
    );
  }
}
