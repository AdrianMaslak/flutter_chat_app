import 'package:flutter/material.dart';
import 'package:training/components/drawer.dart';
import 'package:training/components/user_tile.dart';
import 'package:training/pages/chat_page.dart';
import 'package:training/services/auth/auth_service.dart';
import 'package:training/services/chat/chat_service.dart';
//import 'package:percent_indicator/percent_indicator.dart';

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
    var currentUser = _authService.getCurrentUser();
    if (currentUser != null && userData["email"] != currentUser.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverEmail: userData["email"],
                recieverID: userData["uid"],
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

//Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context){
  //return UserTile()
//}
/*
  Container graph() {
    return Container(
            child: Column(
              children: [
                const Text('kokot'),
                const SizedBox(
                  height: 20,
                ),
                CircularPercentIndicator(
                  radius: 100,
                  lineWidth: 10,
                  percent: 0.8,
                  center: SizedBox(
                    child: new Image.asset('assets/logo.webp'),
                    width: 100,
                    height: 100,
                    ),
                  backgroundColor: Colors.blue,
                  progressColor: Colors.green,
                  
                  )
              ],
            )
          );
  }*/
/*
  Container header() {
    return Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            alignment: Alignment.bottomCenter,
            height: 170,
            decoration: const BoxDecoration(color: Colors.blue),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "User",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(child: Image.asset('assets/logo.webp'),width: 100,),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      child: IconButton(
                        onPressed: logout,
                        icon: const Icon(Icons.settings, size: 25, color: Colors.white,), 
                        ),
                    )
                  ],
                ),
              ],
            ),
          );
  }
}*/