import 'dart:math';

import 'package:chat/core/services/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NickNameSelect extends StatefulWidget {
  const NickNameSelect({super.key});

  @override
  State<NickNameSelect> createState() => _NickNameSelectState();
}

class _NickNameSelectState extends State<NickNameSelect> {
  final nickName = TextEditingController();

  Future<Widget?> _iconValidNickName() async {
    if (nickName.text.length < 4) return null;

    final bool isValidNickName = await _isValidateNick();

    return isValidNickName
        ? const Icon(
            Icons.check,
            color: Color.fromARGB(120, 29, 134, 33),
          )
        : const Icon(
            Icons.close,
            color: Color.fromARGB(120, 134, 18, 3),
          );
  }

  Future<bool> _isValidateNick() async {
    return await AuthService().isValidNickName(nickName.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Escolha um apelido único',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'É por ele que seus amigos vão te encontrar.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        nickName.text = value;
                      });
                    },
                    controller: nickName,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: const Text('Apelido'),
                        suffixIcon: FutureBuilder(
                          future: _iconValidNickName(),
                          builder: (context, snapshot) => snapshot.data == null
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                )
                              : snapshot.data!,
                        )),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (await _isValidateNick())
                    Navigator.of(context).pop(nickName.text);
                  return null;
                },
                child: const Text('Prosseguir'))
          ],
        ),
      ),
    );
  }
}
