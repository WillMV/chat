import 'dart:io';

import 'package:chat/components/input_name_validator.dart';
import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function handleSubmit;
  final AuthFormData formData;
  const AuthForm({
    super.key,
    required this.handleSubmit,
    required this.formData,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool imageError = false;
  bool validName = false;

  void _submit() {
    if (_formKey.currentState!.validate() && validName) {
      widget.handleSubmit(widget.formData);
    }
  }

  void isValidName(bool isValid) {
    setState(() {
      validName = isValid;
    });
  }

  void _handleImage(File image) {
    widget.formData.image = image;
    setState(() => imageError = false);
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
            if (widget.formData.isSigup) ...[
              UserImagePicker(
                onImagePicked: _handleImage,
                onError: imageError,
              ),
              // TextFormField(
              //   key: const ValueKey('name'),
              //   controller: widget.formData.nameController,
              //   keyboardType: TextInputType.name,
              //   validator: (value) => widget.formData.validateName(value),
              //   decoration: const InputDecoration(
              //     label: Text('Nome'),
              //   ),
              // ),
              InputNameValidator(
                name: widget.formData.nameController,
                isValidated: isValidName,
              )
            ],
            TextFormField(
              key: const ValueKey('email'),
              controller: widget.formData.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => widget.formData.validateEmail(value),
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
            TextFormField(
              key: const ValueKey('password'),
              controller: widget.formData.passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) => widget.formData.validatePassword(value),
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
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: Text(
                widget.formData.isLogin ? 'Entrar' : 'Cadastrar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    widget.formData.toogleAuthMode();
                  });
                },
                child: Text(
                  widget.formData.isLogin
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
