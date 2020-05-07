import 'package:flutter/material.dart';

import '../localizations/applocalization.dart';

String getTranslation(BuildContext context, String key) {
  return AppLocalizations.of(context).getTranslatedValue(key);
}
