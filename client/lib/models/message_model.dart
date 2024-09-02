enum MessageType { createClient, sendMessage }

abstract class MessageModel {
  MessageType get messageType;
  String toJson();
}
