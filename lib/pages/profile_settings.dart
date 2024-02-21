import 'package:flutter/material.dart';
import 'package:training/components/text_field.dart';
import 'package:training/services/auth/user_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    Map<String, dynamic>? userData = await _userService.loadUserData();
    if (userData != null && userData.containsKey('username')) {
      _usernameController.text = userData['username'];
    }
  }

  Future<void> _saveUsername() async {
    await _userService.saveUsername(_usernameController.text);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Username save!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Spacing from the top
          Text(
            'USERNAME',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center, // Center align the text
          ),
          const SizedBox(
              height: 8), // Spacing between the label and the input field
          MyTextField(
            hintText: "Enter your username",
            obscureText: false,
            controller: _usernameController,
          ),
          const SizedBox(height: 16), // Spacing before the button
          ElevatedButton(
            onPressed: _saveUsername,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
