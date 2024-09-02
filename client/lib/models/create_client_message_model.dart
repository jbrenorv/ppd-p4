import 'dart:convert';

import 'message_model.dart';
import 'client_model.dart';

class CreateClientMessageModel extends MessageModel {
  CreateClientMessageModel({
    required this.client,
  });

  @override
  MessageType get messageType => MessageType.createClient;

  final ClientModel client;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageType': MessageType.values.indexOf(messageType),
      'client': client.toMap(),
    };
  }

  factory CreateClientMessageModel.fromMap(Map<String, dynamic> map) {
    return CreateClientMessageModel(
      client: ClientModel.fromMap(map['client'] as Map<String,dynamic>),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory CreateClientMessageModel.fromJson(String source) => CreateClientMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CreateClientMessageModel(messageType: $messageType, client: $client)';

  @override
  bool operator ==(covariant CreateClientMessageModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.messageType == messageType &&
      other.client == client;
  }

  @override
  int get hashCode => messageType.hashCode ^ client.hashCode;
}
