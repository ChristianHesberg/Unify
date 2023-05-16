import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unify/Screens/MessageScreen.dart';
import 'package:unify/Widgets/user_text.dart';

import '../chat_service.dart';
import '../models/chat.dart';


class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final chat = Provider.of<ChatService>(context);
    if(user == null) return Container();
    return Scaffold(
      body: StreamBuilder(
        stream: chat.getChats(user),
        builder: (context, snapshot) => ListView(children: [
          if (snapshot.hasData) ...snapshot.data!.map((e) => ChatTile(e))
        ]),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final Chat chat;
  const ChatTile(this.chat, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black12, width: 1),
      ),
      title: UserText(text: chat.name, size: 15),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessageScreen(chat: chat))),
    );
  }
}

