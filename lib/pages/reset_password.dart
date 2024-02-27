import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training/components/text_field.dart';
import 'package:training/components/button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      // If the email field is empty, show a dialog.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Please enter your email address.'),
          );
        },
      );
      return;
    }

    try {
      // Check if the user exists before sending a password reset email.
      final List<String> userSignInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (userSignInMethods.isNotEmpty) {
        // The user exists, send a password reset email.
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Password Reset'),
              content: Text('A password reset link has been sent to $email.'),
            );
          },
        );
      } else {
        // No user associated with the given email, show a dialog.
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('No user found with that email address.'),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth exceptions
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.message.toString()),
          );
        },
      );
    } catch (e) {
      // Handle any other exceptions
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Enter your email and we will send you password reset link",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
          ),
          const SizedBox(height: 30),
          MyButton(text: "Reset password", onTap: passwordReset)
        ],
      ),
    );
  }
}
