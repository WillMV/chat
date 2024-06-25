import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/user_controller.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddContactInput extends StatefulWidget {
  const AddContactInput({super.key});

  @override
  State<AddContactInput> createState() => _AddContactInputState();
}

class _AddContactInputState extends State<AddContactInput> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();

  bool isLoading = false;

  String? errorMessage;

  void _addContact(UserController userController, ChatUser currentUser) async {
    setState(() {
      isLoading = true;
    });

    if (currentUser.name == name.text) {
      setState(() {
        errorMessage = 'É você mesmo :/';
      });
    } else {
      await userController
          .addUserContact(currentUser.name, name.text)
          .onError((error, stackTrace) {
        setState(() {
          errorMessage = error.toString().split(': ')[1];
        });
      });
    }
    _formKey.currentState!.validate();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final authController = Provider.of<AuthController>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Adicionar contato',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: name,
            validator: (value) {
              return errorMessage;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Nome'),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ButtonStyle(
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor:
                MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
          ),
          onPressed: () =>
              _addContact(userController, authController.currentUser!),
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text('Adicionar'),
        )
      ],
    );
  }
}
