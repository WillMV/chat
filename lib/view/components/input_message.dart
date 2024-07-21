import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputMessage extends StatefulWidget {
  final String chatId;
  const InputMessage({super.key, required this.chatId});

  @override
  State<InputMessage> createState() => _InputMessageState();
}

class _InputMessageState extends State<InputMessage> {
  late AuthController authController;
  late ChatController chatController;

  final _msg = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_msg.text.isNotEmpty) {
      final currentUser = authController.currentUser;
      if (currentUser != null) {
        await chatController.save(_msg.text, currentUser, widget.chatId);
        _focusNode.requestFocus();
        _msg.text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    authController = Provider.of<AuthController>(context);
    chatController = Provider.of<ChatController>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        key: const Key('msg_input'),
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
            key: const Key('send_btn'),
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ),
      ),
    );
  }
}
