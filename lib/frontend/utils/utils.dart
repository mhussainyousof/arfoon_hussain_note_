import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

bool isRTL(BuildContext context) {
  final local = Locales.currentLocale(context)?.languageCode;
  return local == 'ps' || local == 'fa';
}