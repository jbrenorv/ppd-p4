import 'dart:convert';

import 'client_model.dart';
import 'message_model.dart';

class SendMessageModel extends MessageModel {
  SendMessageModel({
    required this.message,
    required this.sender,
    required this.recipient,
  });
  
  @override
  MessageType get messageType => MessageType.sendMessage;

  final String message;
  final ClientModel sender;
  final ClientModel recipient;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageType': MessageType.values.indexOf(messageType),
      'messageContent': message,
      'sender': sender.toMap(),
      'recipient': recipient.toMap(),
    };
  }

  factory SendMessageModel.fromMap(Map<String, dynamic> map) {
    return SendMessageModel(
      message: map['messageContent'] as String,
      sender: ClientModel.fromMap(map['sender'] as Map<String,dynamic>),
      recipient: ClientModel.fromMap(map['recipient'] as Map<String,dynamic>),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SendMessageModel.fromJson(String source) => SendMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SendMessageModel(messageType: $messageType, messageContent: $message, sender: $sender, recipient: $recipient)';
  }

  @override
  bool operator ==(covariant SendMessageModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.messageType == messageType &&
      other.message == message &&
      other.sender == sender &&
      other.recipient == recipient;
  }

  @override
  int get hashCode {
    return messageType.hashCode ^
      message.hashCode ^
      sender.hashCode ^
      recipient.hashCode;
  }
}
