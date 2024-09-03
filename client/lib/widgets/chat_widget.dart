import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/client_model.dart';
import '../models/send_message_model.dart';
import '../services/client_service.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.client,
    required this.messages,
    required this.sendMessage,
  });

  final ClientModel? client;
  final List<SendMessageModel> messages;
  final void Function(ClientModel, String) sendMessage;

  @override
  Widget build(BuildContext context) {

    if (client == null) {
      return const Center(
        child: Text(
          'Selecione um contato no menu ao lado para iniciar uma conversa',
        ),
      );
    }

    final inputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: 'Conversando com ',
            children: [
              TextSpan(
                text: client!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ]
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                  },
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) => _buildMessageWidget(
                    messages[messages.length - index - 1],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Digite aqui',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    final message = inputController.text;
                    if (message.isEmpty) return;
                    sendMessage(client!, message);
                  },
                  child: const Text('Enviar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageWidget(SendMessageModel message) {
    var alignment = Alignment.centerLeft;
    var padding = const EdgeInsets.fromLTRB(0.0, 4.0, 32.0, 4.0);
    var color = const Color(0xFFFFCCCC);

    if (ClientService.instance.isMine(message)) {
      alignment = Alignment.centerRight;
      padding = const EdgeInsets.fromLTRB(32.0, 4.0, 0.0, 4.0);
      color = const Color(0xFFCCCCFF);
    }

    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message.message,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
