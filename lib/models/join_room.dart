class JoinRoom {
  final String roomId;
  JoinRoom({required this.roomId});

  Map<String, dynamic> toJson() => {"roomId": roomId};
}
