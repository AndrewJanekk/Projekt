import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/pages/loginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassword = TextEditingController();

  void SignUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmedPassword = _confirmPassword.text;

    if (password != confirmedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password dont match!")));
      return;
    }

    try {
      await authService.signUpWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 70),
        children: [
          //email
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          //password
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextField(
            controller: _confirmPassword,
            decoration: InputDecoration(labelText: "Confirm Password"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          ElevatedButton(
            onPressed: SignUp,
            child: Text("Log in"),

            ),
          SizedBox(height: 12,),

          GestureDetector(
            onTap: () => Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => const LoginPage(),)
            ),
            child: Center(
              child: Text("allready have a account? Log in!"),
            ),
          ),
          
        ],
      ),
    );
  }
}