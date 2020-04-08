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
          }  else {
            return Column(
              children: <Widget>[
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Card(
                    child: Text('Text'),
                  ),
                ),
              Consumer<History>(
                  builder: (ctx, history, child) =>  Expanded(
                    child: history.history.where((entry) => entry.groupId == gName)
                                .toList().length > 0 ? ListView.builder(
                      itemBuilder: (ctx, index) => HistoryEntry(
                            history.history
                                .where((entry) => entry.groupId == gName)
                                .toList()
                                .reversed
                                .toList()[index],
                          ),
                      itemCount: history.history.where((entry) => entry.groupId == gName)
                                .toList().length) : Center(child: Text('No entries added yet!'))
              )),
              ],
            );
          }
        });
  }
}
