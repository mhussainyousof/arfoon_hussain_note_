import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  Size get size => MediaQuery.of(this).size;
  
  bool get isMobile => size.width <400;
  bool get isDesktop => !isMobile;
}
