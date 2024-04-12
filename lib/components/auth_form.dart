import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function handleSubmit;

  const AuthForm({
    super.key,
    required this.handleSubmit,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formData = AuthFormData();
  final _formKey = GlobalKey<FormState>();

  bool imageError = false;

  void _submit() {
    bool hasImage = _formData.image != null;

    if (_formKey.currentState!.validate() && hasImage) {
      widget.handleSubmit(_formData);
    }
    if (!hasImage) {
      setState(() => imageError = true);
    }
  }

  void _handleImage(File image) {
    _formData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            if (_formData.isSigup)
              UserImagePicker(
                onImagePicked: _handleImage,
                onError: imageError,
              ),
            if (_formData.isSigup)
              TextFormField(
                key: const ValueKey('name'),
                controller: _formData.nameController,
                keyboardType: TextInputType.name,
                validator: (value) => _formData.validateName(value),
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
              ),
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
              onPressed: _submit,
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(theme.primaryColor),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)))),
              child: Text(
                _formData.isLogin ? 'Entrar' : 'Cadastrar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
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
