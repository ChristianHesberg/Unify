import 'package:unify/models/app_user.dart';

class ChatKeys {
  static const name = 'name';
  static const users = 'users';
  static const chatId = 'chatId';
}

class Chat{
  final String id;
  final String name;
  final List<String> users;

  Chat(this.id,this.name,this.users);

  Chat.fromMap(this.id, Map<String, dynamic> data)
      : name = data[ChatKeys.name],
       users = [...data[ChatKeys.users]];

  Map<String, dynamic> toMap() {
    return {ChatKeys.name: name, ChatKeys.users: users};
  }
}