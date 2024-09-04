import 'dart:convert';

import 'package:collection/collection.dart';

import 'client_model.dart';
import 'message_model.dart';

class ClientListMessageModel extends MessageModel {
  ClientListMessageModel({
    required this.clients,
  });

  @override
  MessageType get messageType => MessageType.clientList;
  
  final List<ClientModel> clients;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageType': MessageType.values.indexOf(messageType),
      'clients': clients.map((x) => x.toMap()).toList(),
    };
  }

  factory ClientListMessageModel.fromMap(Map<String, dynamic> map) {
    return ClientListMessageModel(
      clients: List<ClientModel>.from(
        (map['clients'] as List).map((x) => ClientModel.fromMap(x)),
      )
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ClientListMessageModel.fromJson(String source) => ClientListMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ClientListMessageModel(messageType: $messageType, clients: $clients)';

  @override
  bool operator ==(covariant ClientListMessageModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.messageType == messageType &&
      listEquals(other.clients, clients);
  }

  @override
  int get hashCode => messageType.hashCode ^ clients.hashCode;
}
