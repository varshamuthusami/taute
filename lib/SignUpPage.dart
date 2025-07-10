import 'package:flutter/material.dart';
import 'package:project_name/Onboarding.dart';
import 'package:project_name/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
bool _isObscured1 = true;
bool _isObscured2 = true;
  void register() async {
    final _authService = AuthService();

    if (passwordController.text == confirmpasswordController.text) {
      try {
        await _authService.signUpWithEmailPassword(
          emailController.text,
          passwordController.text,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Onboarding()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Sign Up'),
      backgroundColor: Colors.amber,
      toolbarHeight: 50.0,
    ),
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height, // Full screen height
        width: double.infinity, // Full width alignment
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo (if any)
              const SizedBox(height: 18),

              // Message or slogan
              const Text(
                "Let's create an account for you",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),

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
                obscureText: _isObscured1,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
          icon: Icon(
            _isObscured2 ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isObscured2 = !_isObscured2; // Toggle visibility
            });
          },
        ),
                ),
              ),
              const SizedBox(height: 18),

              // Confirm Password TextField
              TextField(
                controller: confirmpasswordController,
                obscureText: _isObscured2,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
          icon: Icon(
            _isObscured2 ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isObscured2 = !_isObscured2; // Toggle visibility
            });
          },
        ),
                ),
              ),
              const SizedBox(height: 18),

              // Sign Up Button
              ElevatedButton(
                onPressed: register,
                child: const Text("Sign Up",
                style: TextStyle(
                  color: Colors.black,
                ),
                ),
                
                style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.amber), // Background color
    
   
  ),

              ),
              const SizedBox(height: 18),

              // Already have an account? Login Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login now",
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
                    onPressed: () {
                      // Apple sign-in logic
                    },
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
