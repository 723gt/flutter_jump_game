import 'package:uuid/uuid.dart';

class UserInfo {
  final String clientId;
  UserInfo({required this.clientId});

  UserInfo.fromJson(Map<String, dynamic> json) : clientId = json['clientId'];

  Map<String, dynamic> toJson() => {'clientId': clientId};
}
