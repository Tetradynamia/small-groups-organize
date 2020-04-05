import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../screens/splash_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/group_overview.dart';

class AScreen extends StatelessWidget {
  static const routeName = '/a-screen';
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => Scaffold(
        // appBar: AppBar(title: Text('title'),),
        body: auth.isAuth
            ? GroupOverview()
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen(),
              ),
      ),
    );
  }
}
