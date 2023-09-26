

import 'package:flutter/material.dart';

List<ThemeData> getThemes() {
  return [
    ThemeData(backgroundColor: Colors.blue, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.yellow),),
    ThemeData(backgroundColor: Colors.white, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green)),
    ThemeData(backgroundColor: Colors.purple, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green)),
    ThemeData(backgroundColor: Colors.black, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red)),
    ThemeData(backgroundColor: Colors.red, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue)),
  ];
}