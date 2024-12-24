
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/homepage.dart';
import 'package:flutter_application_1/pages/secondpage.dart';

class Tabbar extends StatelessWidget {
  const Tabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text('Fpay'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.secondary,
                  ),
              ),
              Tab(
                icon: Icon(
                  Icons.money,
                  color: Theme.of(context).colorScheme.secondary,
                  ),
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          HomePage(),
          SecondPage(),
        ]),
      ),
    );
  }
}