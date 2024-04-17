import 'package:flutter/material.dart';

class InputMessage extends StatelessWidget {
  const InputMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          fillColor: Colors.black12,
          filled: true,
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          label: Text('Mensagem'),
          prefixIcon: IconButton(
            icon: Icon(Icons.camera_alt_outlined),
            onPressed: null,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
