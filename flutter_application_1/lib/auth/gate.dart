// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/funcs/TabBar.dart';
import 'package:flutter_application_1/pages/loginPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        //loading 
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator()
              
            ),
          );
        }

        //failid sesion
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return Tabbar();
        } else {
          return LoginPage();
        }
      },
    );
  }
}