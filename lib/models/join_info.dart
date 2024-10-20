import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class JoinInfo {
  final String name;
  late String uuid;
  JoinInfo({required this.name}) {
    const Uuid uuidClass = Uuid();
    uuid = uuidClass.v4();
  }

  Map<String, dynamic> toJson() => {'name': name, 'uuid': uuid};
}
