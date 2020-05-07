import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3/localizations/localization_constants.dart';

import '../models/history.dart';
import '../widgets/history_entry.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gId = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
        future: Provider.of<History>(context, listen: false).getHistory(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<History>(
                builder: (ctx, history, child) => Container(
                  child: history.history
                              .where((entry) => entry.groupId == gId)
                              .toList()
                              .length >
                          0
                      ? ListView.builder(
                          itemBuilder: (ctx, index) => HistoryEntry(
                                history.history
                                    .where((entry) => entry.groupId == gId)
                                    .toList()
                                    .reversed
                                    .toList()[index],
                              ),
                          itemCount: history.history
                              .where((entry) => entry.groupId == gId)
                              .toList()
                              .length)
                      :  Center(
                          child:  Text(getTranslation(context, 'no_history')),
                        ),
                ),
              ),
            );
          }
        });
  }
}
