import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class InputMessage extends StatefulWidget {
  const InputMessage({super.key});

  @override
  State<InputMessage> createState() => _InputMessageState();
}

class _InputMessageState extends State<InputMessage> {
  final _msg = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_msg.text.isNotEmpty) {
      final auth = AuthService();
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        auth.logout();
      }
      await ChatService().save(_msg.text, currentUser!);
      _focusNode.requestFocus();
      _msg.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _msg,
        focusNode: _focusNode,
        onSubmitted: (_) => _sendMessage(),
        textInputAction: TextInputAction.send,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          border: const UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          hintText: 'Mensagem',
          prefixIcon: const IconButton(
            icon: Icon(Icons.camera_alt_outlined),
            onPressed: null,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ),
      ),
    );
  }
}
