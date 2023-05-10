import 'package:flutter/material.dart';
import 'package:unify/Screens/MessageScreen.dart';
import 'package:unify/Screens/SettingsScreen.dart';
import 'package:unify/Widgets/user_text.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black12, width: 1),
            ),
            title: const UserText(text: "Jens",size: 15),
            subtitle: const UserText(text: "blahaha blah", size: 12, color: Colors.black45),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Image border
              child: SizedBox.fromSize(
                size: Size.fromRadius(25), // Image radius
                child: Image.network('https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', fit: BoxFit.cover),
              ),
            ),
          onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MessageScreen(),));
          },
          );
      },),
    );
  }
}
