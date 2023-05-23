import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:unify/models/appUser.dart';

import 'models/baseUrl.dart';
import 'models/chat.dart';
import 'models/message.dart';
import 'models/sender.dart';

class ChatService{
  static const chats = 'chats';
  static const messages = 'messages';
  static const timestamp = 'timestamp';
  final _firestore = FirebaseFirestore.instance;


  ChatService(){
    _firestore.useFirestoreEmulator('localhost', 8080);
  }

  Stream<Iterable<Chat>> getChats(User user) {
    return _firestore
        .collection(chats)
        .where(ChatKeys.userIds, arrayContains: user.uid)
        .withConverter(
      fromFirestore: (snapshot, options) =>
          Chat.fromMap(snapshot.id, snapshot.data()!),
      toFirestore: (value, options) => value.toMap(),
    )
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((e) => e.data()));
  }

  postChat(AppUser user1, AppUser user2) async{
    await http.post(
      Uri.parse('${BaseUrl.baseUrl}chat'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'uid1': user1.id,
        'uid2': user2.id,
        'displayName1': user1.name,
        'displayName2': user2.name
      })
    );
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
    await http.post(
      Uri.parse('${BaseUrl.baseUrl}message'),
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
  }
}