import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unify/Screens/NavigatorScreen.dart';
import 'package:unify/chat_service.dart';
import 'package:unify/match_state.dart';
import 'package:unify/models/appUser.dart';

class ContactUserBtn extends StatelessWidget {
  final AppUser user1;
  final AppUser user2;
  const ContactUserBtn({
    super.key, required this.user1, required this.user2,
  });

  @override
  Widget build(BuildContext context) {
    var chatService = Provider.of<ChatService>(context);
    return TextButton.icon(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(color: Colors.blue),
        backgroundColor: Colors.white,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      onPressed: () {
        chatService.postChat(user1, user2);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NavigatorScreen(startingPosition: 1),));
        MatchState.peopleList.remove(user2);
        MatchState.index--;
      },
      icon: const Icon(Icons.send_sharp,),
      label: const Text('Chat',),
    );
  }
}