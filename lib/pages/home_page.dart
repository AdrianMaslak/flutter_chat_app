import 'package:flutter/material.dart';
import 'package:training/components/drawer.dart';
import 'package:training/components/user_tile.dart';
import 'package:training/pages/chat_page.dart';
import 'package:training/services/auth/auth_service.dart';
import 'package:training/services/chat/chat_service.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('HOME')),
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    String displayText =
        userData.containsKey('username') && userData['username'] != null
            ? userData['username']
            : userData['email'];
    var currentUser = _authService.getCurrentUser();
    if (currentUser != null && userData["email"] != currentUser.email) {
      return UserTile(
        text: displayText,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverEmail: userData["email"],
                recieverID: userData["uid"],
                receiverUsername: displayText,
              ),
            ),
          );
        },
      );
    } else {
      return Container(); // Return an empty container if there's no user or the email matches.
    }
  }
}
