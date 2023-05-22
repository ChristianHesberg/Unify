import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../chat_service.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/sender.dart';

class MessageScreen extends StatelessWidget {
  final padding = 8.0;
  final Chat chat;

  const MessageScreen({required this.chat, super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Chats"), backgroundColor: Colors.black),
      body: Stack(
        children: [
          FirestoreListView<Message>(
            query: chatService.getMessages(chat),
            itemBuilder: (context, doc) {
              final message = doc.data();
              return SingleChildScrollView(
                child: Column(children: [
                  sender(message),
                  textBubble(message),
                  SizedBox(height: padding * 2),
                ]),
              );
            },
          ),
          Align(alignment: Alignment.bottomCenter, child: messageInput(context))
        ],
      ),
    );
  }

  Widget sender(Message message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(message.sender.displayName),
          if (message.timestamp != null) Text(since(message.timestamp!))
        ],
      ),
    );
  }

  Widget textBubble(Message message) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(message.content),
        ),
      ),
    );
  }

  Widget messageInput(BuildContext context) {
    final user = Provider.of<User?>(context);
    final chatService = Provider.of<ChatService>(context);
    return Padding(
      padding: EdgeInsets.all(padding),
      child: TextField(
        keyboardType: TextInputType.text,
        onSubmitted: (value) {
          if (value.isEmpty) return;
          chatService.sendMessage(user!, chat, value);
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.send),
        ),
      ),
    );
  }


  String since(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays > 0) {
      return '${diff.inDays} days';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} min';
    } else {
      return 'Now';
    }
  }
}