import 'package:chat/components/auth_form.dart';
import 'package:chat/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoading = false;

  void onSubmit(AuthFormData authData) {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
              child: SingleChildScrollView(
                  child: AuthForm(
            handleSubmit: onSubmit,
          ))),
          if (isLoading)
            Container(
              decoration: const BoxDecoration(color: Colors.black54),
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              )),
            )
        ],
      ),
    );
  }
}
