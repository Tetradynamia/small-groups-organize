import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/history.dart';
import '../widgets/history_entry.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<History>(context, listen: false).fetchAndSetHistory();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gName = ModalRoute.of(context).settings.arguments;
    final history = Provider.of<History>(context);
    final int itemcount = history.history.values
        .toList()
        .where((entry) => entry.groupName == gName)
        .toList()
        .length;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: <Widget>[
              Container(
                height: 100,
                width: double.infinity,
                child: Card(
                  child: Text('Text'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemBuilder: (ctx, index) => HistoryEntry(
                        history.history.values
                            .toList()
                            .where((entry) => entry.groupName == gName)
                            .toList().reversed.toList()[index],
                        history.history.entries
                            .toList()
                            .where((entry) => entry.value.groupName == gName)
                            .toList().reversed.toList()[index]
                            .key),
                    itemCount: itemcount),
              ),
            ],
          );
  }
}
