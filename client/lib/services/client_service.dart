import 'dart:io';

import 'package:client/models/create_client_message_model.dart';
import 'package:client/models/message_model.dart';

import '../models/send_message_model.dart';
import '../models/client_model.dart';

class ClientService {
  
  ClientService._();

  static final ClientService instance = ClientService._();

  Socket? _socket;

  Future<bool> init(ClientModel client) async {
    try {
      _socket = await Socket.connect('localhost', 1024);
      sendMessage(CreateClientMessageModel(client: client));
      return true;
    } catch (e) {
      return false;
    }
  }

  sendMessage(MessageModel message) {
    
  }
}
