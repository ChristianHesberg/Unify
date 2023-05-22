
import 'package:unify/models/chatUser.dart';


class ChatKeys {
  static const name = 'name';
  static const users = 'users';
  static const chatId = 'chatId';
  static const userIds = 'userIds';
  static const user1 = 'user1';
  static const user2 = 'user2';
}

class Chat{
  final String id;
  final List<ChatUser> users;

  Chat(this.id, this.users);

  Chat.fromMap(this.id, Map<String, dynamic> data)
      : users = [ChatUser.fromMap(data[ChatKeys.users][ChatKeys.user1]), ChatUser.fromMap(data[ChatKeys.users][ChatKeys.user2])];

  Map<String, dynamic> toMap() {
    return {ChatKeys.users: users};
  }
}