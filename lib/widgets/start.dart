import 'package:flutter/material.dart';



class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'You have not added any groups yet! Tap the button below to add some!', textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          
        ),
      ),
    );
  }
}
