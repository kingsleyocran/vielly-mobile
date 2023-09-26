import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarUtil {
  static Widget setStatusBarColorUtil(context, Widget child){
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent status bar
        systemNavigationBarColor: Theme.of(context).colorScheme.background, // navigation bar color
        statusBarIconBrightness: (Theme.of(context).colorScheme.brightness == Brightness.dark) ? Brightness.light : Brightness.dark, // status bar icons' color
        systemNavigationBarIconBrightness: (Theme.of(context).colorScheme.brightness == Brightness.dark) ? Brightness.light : Brightness.dark , //navigation bar icons' color
        //(model.getTheme.selectedThemeMode == ThemeMode.light)? Brightness.light : Brightness.dark,
        ), child: child
    );
  }
}