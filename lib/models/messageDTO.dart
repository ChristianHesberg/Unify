import 'package:unify/models/sender.dart';

class MessageDto{
  final String chatId;
  final String content;
  final Sender sender;

  MessageDto({required this.chatId, required this.content, required this.sender});
}