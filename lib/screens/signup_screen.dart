import 'package:flutter/material.dart';
import '../widgets/auth_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: AuthForm(mode: AuthMode.signup),
      ),
    );
  }
}