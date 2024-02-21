import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart'; // Ensure this import points to your ThemeProvider correctly.

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider once to avoid multiple calls to Provider.of<> in the build method.
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        decoration: BoxDecoration(
          //color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding:
            EdgeInsets.all(16), // Added some padding for aesthetic purposes.
        child: ListView(
          // Using ListView to avoid RenderBox overflow when keyboard appears.
          children: [
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  // No need for 'listen: false' here since we're not within a build method of a widget that's listening.
                  themeProvider.toggleTheme();
                },
              ),
            ),
            // Add more settings here as needed.
          ],
        ),
      ),
    );
  }
}
