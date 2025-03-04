import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up
  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    // Create user profile after sign-up
    if (response.user?.id != null) {
      try {
        await _supabase.from('profiles').insert({
          'id': response.user!.id, // UUID from auth.users
          'username': email.split('@')[0], // Example username
        });
        print("Profile created for user: ${response.user!.id}");
      } catch (e) {
        print("Failed to create profile: $e");
      }
    } else {
      print("User ID is null after sign-up");
    }

    return response;
  }

  // Log out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user id
  String? getCurrentUserId() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.id;
  }

  // Search users by username
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .ilike('username', '%$query%');

      return response;
    } catch (e) {
      throw "Failed to search users: $e";
    }
  }

  // Send friend request
  Future<void> sendFriendRequest(String userId, String friendId) async {
    try {
      await _supabase.from('friends').insert([
        {
          'user_id': userId,
          'friend_id': friendId,
          'status': 'pending',
        }
      ]);
    } catch (e) {
      throw "Failed to send friend request: $e";
    }
  }

  // Get friends list
  Future<List<Map<String, dynamic>>> getFriends(String userId) async {
    try {
      final response = await _supabase
          .from('friends')
          .select('''
            id, 
            status, 
            profiles!friends_friend_id_fkey(id, username)
          ''')
          .or('user_id.eq.$userId,friend_id.eq.$userId')
          .eq('status', 'accepted');

      return response;
    } catch (e) {
      throw "Failed to get friends: $e";
    }
  }
}