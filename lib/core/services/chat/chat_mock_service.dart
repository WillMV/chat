import 'dart:async';

import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';

class ChatMockService implements ChatService {
  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStream = Stream<List<ChatMessage>>.multi((ctl) {
    _controller = ctl;
    ctl.add(_msgs);
  });
  static final List<ChatMessage> _msgs = [
    ChatMessage(
      id: '32',
      text: 'text',
      createdAt: DateTime.now(),
      userId: '1',
      userName: 'userName',
      userImage: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '14',
      text: 'Mensagem normal, do usuario',
      createdAt: DateTime.now(),
      userId: '69',
      userName: 'User',
      userImage: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '1',
      text:
          'Mensagem muito grande por ser grande como sera que vai caber se for enomer gigante colossal monstruosa de grande',
      createdAt: DateTime.now(),
      userId: '2 ',
      userName: 'Pessoa 2',
      userImage: 'assets/images/avatar.png',
    ),
  ];

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return _msgsStream;
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final newMessage = ChatMessage(
      id: _msgs.toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImage: user.imageURL ?? 'assets/images/avatar.png',
    );

    _msgs.add(newMessage);
    _controller?.add(_msgs.reversed.toList());
    return newMessage;
  }
}
