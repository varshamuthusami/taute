import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_name/SignUpPage.dart';
import 'package:project_name/services/auth_service.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final TextEditingController emailController = TextEditingController();
  bool _isProcessing = false;

  Future<void> _recoverPassword() async {
    setState(() {
      _isProcessing = true; // Show loading indicator
    });

    try {
      await AuthService().sendPasswordResetEmail(emailController.text);
      // Show success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent')),
      );
      // Optionally, navigate to login page or clear input
      Navigator.of(context)
          .pop(); // Go back to the previous page (e.g., login page)
    } on FirebaseAuthException catch (e) {
      // Handle errors (e.g., show an alert dialog or snack bar)
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('no user found for that email')),
        );
      }
    } finally {
      setState(() {
        _isProcessing = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Recover Password',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Email text field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              // Recovery button
              _isProcessing
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _recoverPassword,
                      child: Text('Recover Password'),
                    ),
              const SizedBox(height: 20),
              // Create an account prompt
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterPage(
                                onTap: () {},
                              ))); // Replace with your registration page route
                },
                child: Text(
                  "Don't have an account? Create one",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
