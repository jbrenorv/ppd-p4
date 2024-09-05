import 'dart:async';

import 'package:flutter/material.dart';

import '../models/client_list_message_model.dart';
import '../models/client_model.dart';
import '../models/message_model.dart';
import '../models/send_message_model.dart';
import '../services/client_service.dart';
import '../widgets/chat_widget.dart';
import '../widgets/clients_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.client});

  final ClientModel client;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ClientService _service;
  late final StreamSubscription _streamSubscription;
  final _chats = <ClientModel, List<SendMessageModel>>{};

  ClientModel? _selectedClient;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _service = ClientService.instance;
    _streamSubscription = _service.onMessage.listen(_onMessage);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ClientsListWidget(
              connected: _connected,
              client: widget.client,
              onChangeConected: _setConnectionSatatus,
              selectedClient: _selectedClient,
              onChangeSelectedClient: (client) {
                setState(() {
                  _selectedClient = client;
                });
              },
              clients: _chats.keys.toList(),
            ),
          ),
          const VerticalDivider(
            width: 1.0,
          ),
          Expanded(
            flex: 2,
            child: ChatWidget(
              client: widget.client,
              recipient: _selectedClient,
              messages: _selectedClient != null ? _chats[_selectedClient!] ?? [] : [],
              sendMessage: _sendMessage,
              connected: _connected,
            ),
          ),
        ],
      ),
    );
  }

  void _setConnectionSatatus(bool connected) {
    _connected = connected;
    if (_connected) {
      _service.init(widget.client);
    } else {
      _service.disconnect();
    }
    setState(() {});
  }

  void _onMessage(MessageModel message) {
    if (message is ClientListMessageModel) {
      for (var client in message.clients) {
        if (client == widget.client) continue;
        if (_chats[client] == null) {
          _chats[client] = [];
        }
      }
    } else if (message is SendMessageModel) {
      if (message.sender == widget.client) {
        _chats[message.recipient]!.add(message);
      } else {
        if (_chats[message.sender] == null) {
          _chats[message.sender] = [message];
        } else {
          _chats[message.sender]!.add(message);
        }
      }
    }
    setState(() {});
  }

  void _sendMessage(ClientModel recipient, String message) {
    final messageModel = _service.sendMessage(recipient, message);
    _onMessage(messageModel);
  }
}
