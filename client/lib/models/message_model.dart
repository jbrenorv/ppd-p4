enum MessageType { createClient, sendMessage, clientList }

abstract class MessageModel {
  MessageType get messageType;
  String toJson();
}
