import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveConfig {
  static const double mobileMaxWidth = 650;
  static const double tabletMaxWidth = 1024;
  static const double desktopMaxWidth = 1920;

  static const double mobileScale = 1.0;
  static const double tabletScale = 1.1;
  static const double desktopScale = 1.2;

  static List<Breakpoint> get breakpoints => [
    const Breakpoint(start: 0, end: 650, name: MOBILE),
    const Breakpoint(start: 651, end: 1024, name: TABLET),
    const Breakpoint(start: 1025, end: double.infinity, name: DESKTOP),
  ];

  static Widget wrapApp(Widget child) {
    return ResponsiveBreakpoints.builder(breakpoints: breakpoints, child: child);
  }
}
