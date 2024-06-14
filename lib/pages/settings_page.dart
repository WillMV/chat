import 'dart:async';
import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/services/auth/auth_firebase_service.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final currentUser = AuthService().currentUser!;

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
    if (image != null && result) {
      setState(() => isLoading = true);
      await AuthFirebaseService().updateImage(image!);
      setState(() => isLoading = false);
      Navigator.pop(context);
    }
  }

  void _copy() async {
    await Clipboard.setData(ClipboardData(text: currentUser.name));
    setState(() => copied = true);
    Timer(const Duration(seconds: 2), () {
      setState(() => copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          currentUser.name,
                          style: const TextStyle(fontSize: 25),
                        ),
                        IconButton(
                          onPressed: _copy,
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
