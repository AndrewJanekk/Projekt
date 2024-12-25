// ignore_for_file: non_constant_identifier_names

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  //sign in
  Future<AuthResponse> signInWithEmailPassword(
    String email, String password
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password
      );
  }
  //sign up
    Future<AuthResponse> signUpWithEmailPassword(
    String email, String password
  ) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password
      );
  }
  //log out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? GetCurrentUserEmail() {
    final Session = _supabase.auth.currentSession;
    final User = Session?.user;
    return User?.email;
  }

}