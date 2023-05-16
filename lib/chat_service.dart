import 'dart:convert';

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
  static const baseUrl = 'http://10.0.2.2:5001';
  static const basePath = '/unify-ef8e0/us-central1/api/';
  final _firestore = FirebaseFirestore.instance;


  ChatService(){
    _firestore.useFirestoreEmulator('localhost', 8080);
  }

  Stream<Iterable<Chat>> getChats(User user) {
    print('userId is:' + user.uid);
    return _firestore
        .collection(chats)
        .where(ChatKeys.users, arrayContains: user.uid)
        //.orderBy(timestamp)
        .withConverter(
      fromFirestore: (snapshot, options) =>
          Chat.fromMap(snapshot.id, snapshot.data()!),
      toFirestore: (value, options) => value.toMap(),
    )
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((e) => e.data()));
  }

  Query<Message> getMessages(Chat chat){
    return _firestore
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
    print(ChatKeys.chatId + chat.id);
    print(MessageKeys.content + message);
    print(MessageKeys.sender);
    print(SenderKeys.displayName + user.displayName!);
    print(SenderKeys.uid + user.uid);
    //final sender = Sender(
    //  uid: user.uid,
    //  displayName: user.displayName ?? '');
    //MessageDto dto = MessageDto(chatId: chat.id, content: message, sender: sender);
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/unify-ef8e0/us-central1/api/message'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      body: json.encode({
        ChatKeys.chatId: chat.id,
        MessageKeys.content: message,
        MessageKeys.sender: {
          SenderKeys.displayName: user.displayName ?? '',
          SenderKeys.uid: user.uid
        }
      })
    );
    print(response.body);
  }
}