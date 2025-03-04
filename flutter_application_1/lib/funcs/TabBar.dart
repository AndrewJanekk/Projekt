import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/funcs/friend_requests_screen.dart';
import 'package:flutter_application_1/pages/homepage.dart';
import 'package:flutter_application_1/pages/secondpage.dart';
import 'search_friends_screen.dart';

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
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Title(
                    color: Theme.of(context).colorScheme.primary,
                    child: Text("Fpay"),
                  ),
                ),
                SizedBox(height: 5),
                ListTile(
                  title: Text("Search Friends"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchFriendsScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 5),
                ListTile(
                  title: Text("Friends Requests"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FriendRequestsScreen(),
                      )
                    );
                  },
                ),
                Divider(),
                FutureBuilder(
                  future: authService.getFriends(authService.getCurrentUserId()!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text("No friends found");
                    } else {
                      final friends = snapshot.data!;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            final friend = friends[index]['profiles'];
                            return ListTile(
                              title: Text(friend['username']),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: logout,
              icon: Icon(Icons.logout),
            )
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
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelColor: Theme.of(context).colorScheme.secondary,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(text: 'Friends Pay'),
                        Tab(text: "You Pay"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: const [
            HomePage(),
            SecondPage(),
          ],
        ),
      ),
    );
  }
}