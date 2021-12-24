import 'package:wind/models/wind_message_model.dart';

class MutualUser {
  final String name;
  final String? profile;
  final MessageItem lastChat;
  final String time;

  MutualUser({
    required this.name,
    this.profile,
    required this.lastChat,
    required this.time
  });
}