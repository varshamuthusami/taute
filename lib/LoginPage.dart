import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_name/Onboarding.dart';
import 'package:project_name/forgotpassword.dart';
import 'package:project_name/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Loginpage extends StatefulWidget {
  final void Function()? onTap;

  const Loginpage({super.key, required this.onTap});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;
  void Login() async {
    // get the instance of auth service
    final _authService = AuthService();

    //try sign in
    try {
      await _authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Onboarding()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "No Users Found for that Email",
          style: TextStyle(fontSize: 18.0),
        )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Wrong password by the User",
          style: TextStyle(fontSize: 18.0),
        )));
      }
    }
  }

  void forgotPw() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "User tapped forgot password",
        ),
      ),
    );
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Log In'),
      backgroundColor: Colors.amber,
      toolbarHeight: 50.0,
    ),
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height, // Make the container fill the screen height
        width: double.infinity, // Ensure full-width alignment
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Email TextField
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),

              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: _isObscured,
                
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured; // Toggle visibility
            });
          },
        ),
                ),
                
              ),
              const SizedBox(height: 18),

              // Sign In Button
              ElevatedButton(
                onPressed: Login,
                child: const Text("Sign In",
                style: TextStyle(
                  color: Colors.black,
                ),
                ),
                style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.amber), // Background color
    
   
  ),


              ),
              const SizedBox(height: 18),

              // Forgot Password Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Forgot", style: TextStyle(color: Colors.black)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Forgotpassword(),
                        ),
                      );
                    },
                    child: const Text(
                      "Password?",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Social Media Icons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black),
                    onPressed: () {
                      AuthMethods().signInWithGoogle(context);
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                    iconSize: 30,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Register Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?", style: TextStyle(color: Colors.black)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Register now",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
