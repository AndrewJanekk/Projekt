import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class SearchFriendsScreen extends StatefulWidget {
  const SearchFriendsScreen({super.key});

  @override
  _SearchFriendsScreenState createState() => _SearchFriendsScreenState();
}

class _SearchFriendsScreenState extends State<SearchFriendsScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];

  Future<void> _searchUsers() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    final users = await _authService.searchUsers(query);
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Friends'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchUsers,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user['username']),
                  trailing: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      final currentUserId = _authService.getCurrentUserId(); // Zastąp prawdziwym ID użytkownika
                      _authService.sendFriendRequest(currentUserId!, user['id']);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}