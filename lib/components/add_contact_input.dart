import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/user/user_service.dart';
import 'package:flutter/material.dart';

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

  void _addContact() async {
    setState(() {
      isLoading = true;
    });

    final currentUser = AuthService().currentUser;

    if (currentUser!.name == name.text) {
      setState(() {
        errorMessage = 'É você mesmo :/';
      });
    } else {
      final findContact = await UserService()
          .addContact(name.text)
          .onError((error, stackTrace) {
        setState(() {
          errorMessage = error.toString().split(': ')[1];
        });
        return true;
      });

      if (!findContact) {
        setState(() {
          errorMessage = 'Usuário não encontrado';
        });
      }
    }
    _formKey.currentState!.validate();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: _addContact,
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
