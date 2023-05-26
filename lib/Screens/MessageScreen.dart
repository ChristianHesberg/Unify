import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat_service.dart';
import '../user_state.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../user_service.dart';

class MessageScreen extends StatelessWidget {
  final padding = 8.0;
  final Chat chat;
  final ScrollController controller = ScrollController();

  MessageScreen({required this.chat, super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final userService = Provider.of<UserService>(context);
    var uId = UserState.user!.id;
    return Scaffold(
      appBar: AppBar(title: const Text("Chats"), backgroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(
            child: FirestoreListView<Message>(
              controller: controller,
              query: chatService.getMessages(chat),
              itemBuilder: (context, doc) {
                final message = doc.data();
                return SingleChildScrollView(
                  child: Column(children: [
                    sender(message, uId),
                    _createBubble(message, uId),
                    SizedBox(height: padding * 2),
                  ]),
                );
              },
            ),
          ),
          _buildMessageBar(chatService, userService)
        ],
      ),
    );
  }

  _createBubble(Message message, String uId) {
    if (message.sender.uid == uId) {
      return BubbleNormal(
        textStyle: const TextStyle(fontSize: 20, color: Colors.white),
        text: message.content,
        color: const Color(0xFF1B97F3),
        isSender: true,
      );
    }
    return BubbleNormal(
      text: message.content,
      textStyle: const TextStyle(fontSize: 20),
      color: Color(0xFFE8E8EE),
      isSender: false,
    );
  }

  Widget sender(Message message, String uId) {
    var senderId = message.sender.uid;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        mainAxisAlignment:
        uId == senderId ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(message.sender.displayName),
          const SizedBox(width: 10,), //spacing
          if (message.timestamp != null) Text(since(message.timestamp!))
        ],
      ),
    );
  }

  _buildMessageBar(ChatService chatService, UserService userService) {
    return MessageBar(
      onSend: (value) async {
        if (value.isEmpty) return;
        await chatService.sendMessage(UserState.user!, chat, value);
        controller.jumpTo(controller.position.maxScrollExtent);
      },
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
