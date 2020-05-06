import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


import './models/history.dart';
import './screens/group_overview.dart';
import './screens/manage_groups_screen.dart';
import './models/members_groups_model.dart';
import './screens/tabs_screen.dart';
import './localizations/applocalization.dart';
import './screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  bool _localeLoaded = false;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

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
        locale: _locale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fi', 'FI'),
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          if (_locale == null) {
            for (Locale locale in supportedLocales) {
              if (locale.languageCode == deviceLocale.languageCode &&
                  locale.countryCode == deviceLocale.countryCode) {
                _locale = deviceLocale;
              }
            }
            _locale = supportedLocales.first;
          }
          return _locale;
        },
        home: GroupOverview(),
        routes: {
          TabsScreen.routeName: (ctx) => TabsScreen(),
          ManageGroupsScreen.routeName: (ctx) => ManageGroupsScreen(),
          GroupOverview.routeName: (ctx) => GroupOverview(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
        },
      ),
    );
  }
}
