import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/pages/Grups.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _userGroups = [];

  @override
  void initState() {
    super.initState();
    _fetchUserGroups();
  }

  Future<void> _fetchUserGroups() async {
    try {
      final userId = _authService.getCurrentUserId();
      final response =
          await _supabase.from('groups').select().eq('created_by', userId!);
      setState(() {
        _userGroups = response;
      });
    } catch (e) {
      print("Błąd ładowania grup: $e");
    }
  }

  Future<void> _deleteGroup(int groupId) async {
    await _supabase.from('groups').delete().eq('id', groupId);
    _fetchUserGroups();
  }

  Future<void> _addMemberToGroup(int groupId) async {
    final friends =
        await _authService.getFriends(_authService.getCurrentUserId()!);
    final selectedFriend = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Dodaj znajomego"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index]['profiles'];
              return ListTile(
                title: Text(friend['username']),
                onTap: () => Navigator.pop(context, friend),
              );
            },
          ),
        ),
      ),
    );

    if (selectedFriend != null) {
      await _authService.addMemberToGroup(groupId, selectedFriend['id']);
      _fetchUserGroups();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewGroup(context),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _userGroups.length,
        itemBuilder: (context, index) {
          final group = _userGroups[index];
          return Groups(
            groupName: group['name'],
            groupId: group['id']
                .toString(), // Upewnij się, że `groupId` jest typu `String`
            totalAmount: group['total_amount'] ?? 0.0,
            deleteFunction: (context) => _deleteGroup(group['id'] as int),
            onAddMember: (String groupId) =>
                _addMemberToGroup(int.parse(groupId)),
          );
        },
      ),
    );
  }

  Future<void> _createNewGroup(BuildContext context) async {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nowa grupa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: "Nazwa grupy"),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Kwota"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final amount = double.tryParse(_amountController.text) ?? 0.0;
              await _authService.createGroup(
                _nameController.text,
                amount,
              );
              _fetchUserGroups();
              Navigator.pop(context);
            },
            child: const Text("Zapisz"),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
