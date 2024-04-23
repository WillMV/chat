import 'package:chat/components/auth_form.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final authSevice = AuthService();

  bool isLoading = false;

  ScaffoldFeatureController _showErrorMessage(Object e) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void onSubmit(AuthFormData authData) async {
    if (!mounted) return;

    setState(() => isLoading = true);
    try {
      if (authData.isLogin) {
        await authSevice.login(
          authData.email,
          authData.password,
        );
      } else {
        await authSevice.signup(
          authData.name,
          authData.email,
          authData.password,
          authData.image,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage(e);
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
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
