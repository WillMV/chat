import 'dart:async';
import 'dart:io';
import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/user_controller.dart';
import 'package:chat/view/components/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = false;
  bool copied = false;
  File? image;

  void _handleImage(File? img) {
    if (img != null) {
      setState(() => image = img);
    }
  }

  void _save() async {
    final bool result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Salvar alterações?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Não')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sim')),
        ],
      ),
    );
    // TODO: Corrigir o save da imagem de perfil convertendo o File, updando ele e pegando o link, precisa criar função de upar a imagem na storage do firebase.

    // if (image != null && result) {
    //   setState(() => isLoading = true);
    //   // await userController.updateCurrentUser(image!);
    //   setState(() => isLoading = false);
    //   Navigator.pop(context);
    // }
  }

  void _copy(AuthController authController) async {
    await Clipboard.setData(
        ClipboardData(text: authController.currentUser!.name));
    setState(() => copied = true);
    Timer(const Duration(seconds: 2), () {
      setState(() => copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    // final userController = Provider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      UserImagePicker(
                        onImagePicked: _handleImage,
                        onError: false,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Text(
                          authController.currentUser!.name,
                          style: const TextStyle(fontSize: 25),
                        ),
                        IconButton(
                          onPressed: () => _copy(authController),
                          icon: const Icon(Icons.copy),
                        )
                      ]),
                      if (copied) const Text('Copiado!')
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        if (isLoading)
          Container(
            decoration: const BoxDecoration(color: Colors.black54),
            child: const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
          )
      ]),
    );
  }
}
