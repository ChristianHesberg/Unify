class ChatKeys {
  static const users = 'users';
}

class Chat{
  final String id;
  final List<String> users;

  Chat(this.id, this.users);

  Chat.fromMap(this.id, Map<String, dynamic> data)
      : users = [...data[ChatKeys.users]];

  Map<String, dynamic> toMap() {
    return {ChatKeys.users: users};
  }
}