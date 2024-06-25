class ChatUser {
  final String id;
  final String email;
  final String name;
  String? imageUrl;

  ChatUser({
    required this.id,
    required this.email,
    required this.name,
    this.imageUrl,
  });
}
