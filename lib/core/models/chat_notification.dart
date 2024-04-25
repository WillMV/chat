class ChatNotification {
  final String title;
  final String body;

  ChatNotification({required this.title, required this.body});

  toJson() {
    return {
      'title': title,
      'body': body,
    };
  }
}
