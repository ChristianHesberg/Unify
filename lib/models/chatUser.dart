class ChatUserKeys{
  static const uid = 'uid';
  static const displayName = 'displayName';
  static const picture = 'picture';
}

class ChatUser{
  final String uid;
  final String displayName;
  final String picture;

  ChatUser(this.uid, this.displayName, this.picture);

  ChatUser.fromMap(Map<String, dynamic> data)
    :   uid = data[ChatUserKeys.uid],
        displayName = data[ChatUserKeys.displayName],
        picture = data[ChatUserKeys.picture];

  Map<String, dynamic> toMap() {
    return {
      ChatUserKeys.uid: uid,
      ChatUserKeys.displayName: displayName,
      ChatUserKeys.picture: picture
    };
  }
}