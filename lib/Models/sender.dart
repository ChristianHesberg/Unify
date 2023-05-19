class SenderKeys {
  static const uid = 'uid';
  static const displayName = 'displayName';
}

class Sender {
  final String uid;
  final String displayName;

  Sender({required this.uid, required this.displayName});

  Sender.fromMap(Map<String, dynamic> data)
      : uid = data[SenderKeys.uid],
        displayName = data[SenderKeys.displayName];

  toMap() {
    return {
      SenderKeys.uid: uid,
      SenderKeys.displayName: displayName,
    };
  }
}