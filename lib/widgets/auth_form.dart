import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

enum AuthMode { login, signup }

class AuthForm extends StatefulWidget {
  final AuthMode mode;
  const AuthForm({super.key, required this.mode});
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
        TextFormField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () async {
            if (widget.mode == AuthMode.login) {
              await auth.signIn(_email.text.trim(), _password.text);
            } else {
              await auth.signUp(_email.text.trim(), _password.text);
            }
            if (mounted) Navigator.of(context).pop();
          },
          child: Text(widget.mode == AuthMode.login ? 'Login' : 'Sign up'),
        )
      ]),
    );
  }
}