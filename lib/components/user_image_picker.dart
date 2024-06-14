import 'dart:io';

import 'package:chat/core/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File?) onImagePicked;
  final bool onError;

  const UserImagePicker(
      {super.key, required this.onImagePicked, required this.onError});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  @override
  void didUpdateWidget(covariant UserImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.onError) {
      setState(() {});
    }
  }

  void _imagePick() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;
    await showDialog(
        context: context,
        builder: (context) => Center(
              child: Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        pickedImage =
                            await picker.pickImage(source: ImageSource.camera);
                        Navigator.pop(context);
                      },
                      label: const Text('Câmera'),
                      icon: const Icon(Icons.camera),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        pickedImage =
                            await picker.pickImage(source: ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      label: const Text('Galeria'),
                      icon: const Icon(Icons.image),
                    )
                  ],
                ),
              ),
            ));

    setState(() {});

    if (pickedImage != null) {
      _image = File(pickedImage!.path);
      widget.onImagePicked(_image);
    }
  }

  CircleAvatar userAvatar() {
    final user = AuthService().currentUser;
    return _image == null
        ? CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: user == null ? null : NetworkImage(user.imageURL!),
            radius: 40,
          )
        : CircleAvatar(
            backgroundImage: FileImage(_image!),
            radius: 40,
          );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          if (widget.onError)
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.error,
                  radius: 42,
                ),
                Positioned(bottom: 2, left: 2, child: userAvatar()),
              ],
            ),
          if (!widget.onError) userAvatar(),
          const SizedBox(
            height: 10,
          ),
          if (widget.onError)
            Text(
              'Selecione alguma imagem',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          TextButton.icon(
              onPressed: _imagePick,
              icon: Icon(Icons.image, color: theme.primaryColor),
              label: Text(
                'Adicionar imagem',
                style: TextStyle(color: theme.primaryColor),
              )),
        ],
      ),
    );
  }
}
