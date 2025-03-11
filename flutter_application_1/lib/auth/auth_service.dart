import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  AuthService() {
    print("Supabase client is ready!");
  }
  

  // logowanie 
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // rejestracja
  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    
    if (response.user?.id != null) {
      try {
        await _supabase.from('profiles').insert({
          'id': response.user!.id, 
          'username': email.split('@')[0], 
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
    print("Current user: $user");
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

 
  Future<List<Map<String, dynamic>>> getPendingFriendRequests(String userId) async {
    try {
      final response = await _supabase
          .from('friends')
          .select('''
            id, 
            user_id, 
            profiles!friends_user_id_fkey(id, username)
          ''')
          .eq('friend_id', userId)
          .eq('status', 'pending');

      return response;
    } catch (e) {
      throw "Failed to get pending friend requests: $e";
    }
  }

 
  Future<void> acceptFriendRequest(int friendshipIdInt) async {
    try {
      await _supabase
          .from('friends')
          .update({'status': 'accepted'})
          .eq('id', friendshipIdInt);
    } catch (e) {
      throw "Failed to accept friend request: $e";
    }
  }


Future<Map<String, dynamic>> createGroup(String groupName, double amount) async {
  final currentUserId = getCurrentUserId();
  if (currentUserId == null) throw "User not logged in";

  try {
    final response = await _supabase
        .from('groups')
        .insert({
          'name': groupName,
          'created_by': currentUserId,
        })
        .select() 
        .single(); 

    return response;
  } catch (e) {
    throw "Failed to create group: $e";
  }
}


  Future<void> addMemberToGroup(int groupId, String userId) async {
    final currentUserId = getCurrentUserId();
    if (currentUserId == null) throw "User not logged in";

    try {
      await _supabase.from('group_members').insert({
        'group_id': groupId,
        'user_id': userId,
        'added_by': currentUserId,
      });
    } catch (e) {
      throw "Failed to add member to group: $e";
    }
  }

 
  Future<List<Map<String, dynamic>>> getUserGroups() async {
    final currentUserId = getCurrentUserId();
    if (currentUserId == null) throw "User not logged in";

    try {
      final response = await _supabase
          .from('groups')
          .select()
          .eq('created_by', currentUserId);

      return response;
    } catch (e) {
      throw "Failed to get user groups: $e";
    }
  }

 
  Future<List<Map<String, dynamic>>> getGroupMembers(int groupId) async {
    try {
      final response = await _supabase
          .from('group_members')
          .select('''
            id, 
            user_id, 
            profiles!group_members_user_id_fkey(id, username)
          ''')
          .eq('group_id', groupId);

      return response;
    } catch (e) {
      throw "Failed to get group members: $e";
    }
  }

  
  Future<void> removeMemberFromGroup(int groupId, String userId) async {
    try {
      await _supabase
          .from('group_members')
          .delete()
          .eq('group_id', groupId)
          .eq('user_id', userId);
    } catch (e) {
      throw "Failed to remove member from group: $e";
    }
  }

  // Usuwanie grupy
  Future<void> deleteGroup(int groupId) async {
    try {
      await _supabase.from('groups').delete().eq('id', groupId);
    } catch (e) {
      throw "Failed to delete group: $e";
    }
  }
    Future<double> getAmountToPay(String userId) async {
    try {
      final response = await _supabase
          .from('user_debts')
          .select('amount')
          .eq('user_id', userId)
          .single();

      return response['amount'] ?? 0.0;
    } catch (e) {
      print("Failed to fetch amount to pay: $e");
      return 0.0;
    }
  }

}
