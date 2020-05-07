import 'package:flutter/material.dart';
import '../localizations/localization_constants.dart';



class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child:  Text(
        getTranslation(context, 'start'), textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          
        ),
      ),
    );
  }
}
