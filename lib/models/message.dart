import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unify/models/sender.dart';

class MessageKeys {
  static const timestamp = 'timestamp';
  static const sender = 'sender';
  static const content = 'content';
}

class Message {
  final String id;
  final DateTime? timestamp;
  final Sender sender;
  final String content;

  Message(this.id, this.timestamp, this.sender, this.content);


  Message.fromMap(this.id, Map<String, dynamic> data)
      : timestamp = (data[MessageKeys.timestamp] as Timestamp?)?.toDate(),
        sender = Sender.fromMap(data[MessageKeys.sender]),
        content = data[MessageKeys.content];

  Map<String, dynamic> toMap() {
    return {
      MessageKeys.timestamp: timestamp,
      MessageKeys.sender: sender,
      MessageKeys.content: content
    };
  }
}