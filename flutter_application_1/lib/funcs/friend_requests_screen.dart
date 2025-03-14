import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  _FriendRequestsScreenState createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _pendingRequests = [];

  @override
  void initState() {
    super.initState();
    _loadPendingRequests();
  }

  Future<void> _loadPendingRequests() async {
    final currentUserId = _authService.getCurrentUserId();
    if (currentUserId == null) return;

    try {
      final requests =
          await _authService.getPendingFriendRequests(currentUserId);
      setState(() {
        _pendingRequests = requests;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load requests: $e")),
      );
    }
  }

  Future<void> _acceptRequest(String friendshipId) async {
    print("Accepting friend request with ID: $friendshipId");
    try {
      final friendshipIdInt = int.parse(friendshipId);
      await _authService.acceptFriendRequest(friendshipIdInt);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Friend request accepted!")),
      );
      _loadPendingRequests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to accept request: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
      ),
      body: _pendingRequests.isEmpty
          ? const Center(child: Text("No pending friend requests"))
          : ListView.builder(
              itemCount: _pendingRequests.length,
              itemBuilder: (context, index) {
                final request = _pendingRequests[index];
                final profile = request['profiles'];
                return ListTile(
                  title: Text(profile['username']),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () => _acceptRequest(request['id'].toString()),
                  ),
                );
              },
            ),
    );
  }
}
