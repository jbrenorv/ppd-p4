// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:client/models/client_list_message_model.dart';

import '../models/client_model.dart';
import '../models/create_client_message_model.dart';
import '../models/message_model.dart';
import '../models/send_message_model.dart';

class ClientService {
  
  ClientService._();

  static final ClientService instance = ClientService._();

  Socket? _socket;
  ClientModel? _client;

  final _streamController = StreamController<MessageModel>();
  Stream<MessageModel> get onMessage => _streamController.stream;

  Future<bool> init(ClientModel client) async {
    try {
      _client = client;
      _socket = await Socket.connect('localhost', 1024);
      _socket!.encoding = utf8;
      _socket!.listen(
        _receiveMessageFromRemoteServer,
        cancelOnError: true,
      );
      return true;
    } catch (e) {
      print(e);
      _socket?.close();
      _socket = null;
      _client = null;
      return false;
    }
  }

  bool isMine(SendMessageModel message) {
    return _client?.id == message.sender.id;
  }

  SendMessageModel sendMessage(ClientModel recipient, String message) {
    final messageModel = SendMessageModel(
      message: message,
      sender: _client!,
      recipient: recipient,
    );
    _sendMessageToRemoteServer(messageModel);
    return messageModel;
  }

  void _receiveMessageFromRemoteServer(Uint8List rawData) {
    final json = utf8.decode(rawData).trim();

    print('Message received: $json');
    
    if (json.endsWith('available')) {
      //         channel-available

      Future.delayed(const Duration(seconds: 3), () {

      _sendMessageToRemoteServer(CreateClientMessageModel(client: _client!));
      });

      print('heree');
      return;
    }
    else {
      print("diferente $json");
    }

    final map = jsonDecode(json);

    if (MessageType.values[map['messageType'] as int] == MessageType.clientList) {
      _streamController.add(ClientListMessageModel.fromMap(map));
    } else {
      _streamController.add(SendMessageModel.fromMap(map));
    }
  }

  Future<void> _sendMessageToRemoteServer(MessageModel message) async {
    await _socket!.flush();

    final json = message.toJson();

    print('Message sent: $json');

    _socket!.write(json);
  }
}
