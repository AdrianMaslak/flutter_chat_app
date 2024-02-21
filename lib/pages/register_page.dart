import 'package:flutter/material.dart';
import 'package:training/services/auth/auth_service.dart';
import 'package:training/components/button.dart';
import 'package:training/components/text_field.dart';

class RegisterPage extends StatelessWidget {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confrirmPasswordController = TextEditingController();
  final void Function()? onTap;
   
   RegisterPage({
    super.key,
    required this.onTap,
    
    });
    void register(BuildContext context) {
      //get auth service
      final _auth = AuthService();
      if(_passwordController.text == _confrirmPasswordController.text){
        try{
        _auth.signUpWithEmailPassword(_emailController.text, _passwordController.text);
        } catch(e){
          showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
          ));
        }
      } else{
        showDialog(context: context, 
        builder: (context) => const AlertDialog(
        title: Text('Passwords do not match'),
        ));
      }     
    }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message, 
            size: 60,
            color: Theme.of(context).colorScheme.primary,
            ),

            Text("Let's create account",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                
              ),
            ),
            const SizedBox(height: 10),

            MyTextField(hintText: "Email",
            obscureText: false,
            controller: _emailController,
            ),

            const SizedBox(height: 10,
            ),

            MyTextField(hintText: "Password",
            obscureText: true,
            controller: _passwordController,
            ),

              const SizedBox(height: 10),

             MyTextField(hintText: "Confirm Password",
            obscureText: true,
            controller: _confrirmPasswordController,
            ),

            const SizedBox(height:  25,
            ),
            
            MyButton(
              text: 'Register',
              onTap: ()=> register(context),
              ),
            
            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 3),
                GestureDetector(
                  onTap: onTap,
                  child: Text('Login now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}