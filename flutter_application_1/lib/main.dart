// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/funcs/TabBar.dart';
import 'package:flutter_application_1/themes/themes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


/// Flutter code sample for [Scaffold].

void main() async {
  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt6cWJmc2FraGJ6b3ZtYXBkaG1vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUxNDkxOTQsImV4cCI6MjA1MDcyNTE5NH0.Txk6JDm4TkduJ5O5z8oECjvYNtduwiKHeGAkPlZANVA",
    url: "https://kzqbfsakhbzovmapdhmo.supabase.co",
  );
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