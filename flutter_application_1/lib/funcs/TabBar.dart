// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/pages/homepage.dart';
import 'package:flutter_application_1/pages/secondpage.dart';

class Tabbar extends StatelessWidget {
   Tabbar({super.key});

  final authService = AuthService();

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: logout
            , icon: Icon(Icons.logout))
          ],
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text('Fpay'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
             child: Column(
               children: [
                Container(
                  height: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                 Padding(
                   padding: const EdgeInsets.only(left: 25, right: 25),
                   child: Container(
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        labelColor: Theme.of(context).colorScheme.secondary,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Tab(text: 'home',),
                          Tab(text: "Sec",)
                        ]),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      
                      
                    ),
                               
                   ),
                 ),
               ],
             )
            )
        ),
        body: TabBarView(children: [
          HomePage(),
          SecondPage(),
        ]),
      ),
    );
  }
}