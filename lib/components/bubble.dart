import 'package:flutter/material.dart';

class MyBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const MyBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Colors.lightBlueAccent
            : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15),
          bottomRight: const Radius.circular(15),
          topRight: !isCurrentUser
              ? const Radius.circular(15)
              : const Radius.circular(0),
          // Assuming you want the bottom left to be rounded for messages from others
          bottomLeft: isCurrentUser
              ? const Radius.circular(15)
              : const Radius.circular(0),
        ),
      ),
      padding: const EdgeInsets.all(
          10), // Add some padding to the text inside the container
      child: Text(message),
    );
  }
}
