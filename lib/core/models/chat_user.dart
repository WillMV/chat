class ChatUser {
  final String id;
  final String email;
  final String name;
  String? imageURL;

  ChatUser({
    required this.id,
    required this.email,
    required this.name,
    this.imageURL,
  });
}
