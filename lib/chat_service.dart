import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unify/models/messageDTO.dart';
import 'package:http/http.dart' as http;

import 'models/chat.dart';
import 'models/message.dart';
import 'models/sender.dart';

class ChatService{
  static const chats = 'chats';
  static const messages = 'messages';
  static const timestamp = 'timestamp';
  static const baseUrl = 'http://127.0.0.1:5001/unify-ef8e0/us-central1/api/';

  ChatService(){
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }

  Query<Message> getMessages(Chat chat){
    return FirebaseFirestore.instance
        .collection(chats)
        .doc(chat.id)
        .collection(messages)
        .orderBy(MessageKeys.timestamp)
        .withConverter(
      fromFirestore: (snapshot, options) =>
          Message.fromMap(snapshot.id, snapshot.data()!),
      toFirestore: (value, options) => value.toMap(),
    );
  }

  sendMessage(User user, Chat chat, String message) async {
    final sender = Sender(
      uid: user.uid,
      displayName: user.displayName ?? '');
    MessageDto dto = MessageDto(chatId: chat.id, content: message, sender: sender);
    final response = await http.post(
      Uri.http('${baseUrl}message'),
      body: dto
    );
    print(response);
  }
}