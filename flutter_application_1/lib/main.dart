// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/funcs/TabBar.dart';
import 'package:flutter_application_1/themes/themes.dart';


/// Flutter code sample for [Scaffold].

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tabbar(),
      theme: lightmode,
      darkTheme: darkmode,
    );
  }
}