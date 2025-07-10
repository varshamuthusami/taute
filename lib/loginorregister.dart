import 'package:flutter/material.dart';
import 'package:project_name/LoginPage.dart';
import 'package:project_name/SignUpPage.dart';


class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Loginpage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
