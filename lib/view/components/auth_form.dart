import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/view/components/input_name_validator.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  final Function(AuthFormData, AuthController) handleSubmit;
  const AuthForm({
    super.key,
    required this.handleSubmit,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  bool imageError = false;
  bool validName = false;

  void _submit(AuthController authController) {
    if (_formKey.currentState!.validate() && (validName || _formData.isLogin)) {
      widget.handleSubmit(_formData, authController);
    }
  }

  void isValidName(bool isValid) {
    validName = isValid;
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            if (_formData.isSigup) ...[
              InputNameValidator(
                name: _formData.nameController,
                isValidated: isValidName,
              )
            ],
            TextFormField(
              key: const ValueKey('email'),
              controller: _formData.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => _formData.validateEmail(value),
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
            TextFormField(
              key: const ValueKey('password'),
              controller: _formData.passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) => _formData.validatePassword(value),
              decoration: const InputDecoration(
                label: Text('Senha'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              key: const Key('submit_button'),
              onPressed: () => _submit(authController),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(theme.primaryColor),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: Text(
                _formData.isLogin ? 'Entrar' : 'Cadastrar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
                key: const Key('login_or_singup_button'),
                onPressed: () {
                  setState(() {
                    _formData.toogleAuthMode();
                  });
                },
                child: Text(
                  _formData.isLogin
                      ? 'Criar uma nova conta?'
                      : 'Já possui uma conta?',
                  style: TextStyle(color: theme.primaryColor),
                ))
          ]),
        ),
      ),
    );
  }
}
