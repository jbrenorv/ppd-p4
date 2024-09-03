import 'package:flutter/material.dart';

import '../models/client_model.dart';
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
  final _chats = <ClientModel, List<SendMessageModel>>{};
  ClientModel? _selectedClient;

  @override
  void initState() {
    super.initState();
    _service = ClientService.instance;
    _service.init(widget.client);
    _service.onMessage.listen(_onMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ClientsListWidget(
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
              client: _selectedClient,
              messages: _selectedClient != null ? _chats[_selectedClient!] ?? [] : [],
              sendMessage: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _onMessage(SendMessageModel message) {
    if (_chats[message.recipient] == null) {
      _chats[message.recipient] = [message];
    } else {
      _chats[message.recipient]!.add(message);
    }
    setState(() {});
  }

  void _sendMessage(ClientModel recipient, String message) {
    final messageModel = _service.sendMessage(recipient, message);
    _onMessage(messageModel);
  }
}
