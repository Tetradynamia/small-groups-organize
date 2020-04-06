import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/history.dart';
import '../widgets/history_entry.dart';

class HistoryScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    print('building history');
    final gName = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
        future:
            Provider.of<History>(context, listen: false).getHistory(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: <Widget>[
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Card(
                    child: Text('Text'),
                  ),
                ),
                Expanded(
                    child: Consumer<History>(
                  builder: (ctx, history, child) => ListView.builder(
                      itemBuilder: (ctx, index) => HistoryEntry(
                            history.history
                                .where((entry) => entry.groupName == gName)
                                .toList()
                                .reversed
                                .toList()[index],
                          ),
                      itemCount: 3),
                )),
              ],
            );
          }
        });
  }
}
