import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class ObligationsPage extends StatefulWidget {
  const ObligationsPage({super.key});

  @override
  _ObligationsPageState createState() => _ObligationsPageState();
}

class _ObligationsPageState extends State<ObligationsPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _obligations = [];

  @override
  void initState() {
    super.initState();
    _fetchObligations();
  }

  Future<void> _fetchObligations() async {
    try {
      final userId = _authService.getCurrentUserId();
      final response = await _supabase
          .from('group_members')
          .select('amount_owed, groups (name, created_by)')
          .eq('user_id', userId!)
          .gt('amount_owed', 0);

      setState(() {
        _obligations = response;
      });
    } catch (e) {
      print("Błąd ładowania zobowiązań: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: ListView.builder(
        itemCount: _obligations.length,
        itemBuilder: (context, index) {
          final obligation = _obligations[index];
          final group = obligation['groups'] as Map<String, dynamic>;
          return ListTile(
            title: Text(group['name']),
            subtitle: Text(
              "Do oddania: ${obligation['amount_owed']} zł dla grupy ${group['name']}",
            ),
          );
        },
      ),
    );
  }
}
