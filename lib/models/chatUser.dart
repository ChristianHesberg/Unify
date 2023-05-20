class ChatUserKeys{
  static const uid = 'uid';
  static const displayName = 'displayName';
  static const picture = 'picture';
}

class ChatUser{
  final String uid;
  final String displayName;

  ChatUser(this.uid, this.displayName);

  ChatUser.fromMap(Map<String, dynamic> data)
    :   uid = data[ChatUserKeys.uid],
        displayName = data[ChatUserKeys.displayName];

  Map<String, dynamic> toMap() {
    return {
      ChatUserKeys.uid: uid,
      ChatUserKeys.displayName: displayName
    };
  }
}