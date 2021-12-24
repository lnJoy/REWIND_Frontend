// class ChatMessages {
//   late List<MessageItem> _messages;
//
//   List<MessageItem> get getMessages => _messages;
//   set setMessages(List<MessageItem> messages) => _messages = messages;
// }

class MessageItem {
  final int chatid;
  final String messageType;
  final String messageContent;
  final String messageCreatedAt;

  MessageItem({
    required this.chatid,
    required this.messageType,
    required this.messageContent,
    required this.messageCreatedAt
  });

  @override
  String toString() => messageCreatedAt;
}