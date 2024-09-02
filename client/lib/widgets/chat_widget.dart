import 'package:flutter/material.dart';

import '../models/client_model.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.client,
    required this.sendMessage,
  });

  final ClientModel client;
  final void Function(ClientModel, String) sendMessage;

  @override
  Widget build(BuildContext context) {
    final inputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversando com ${client.name}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Container(),
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
                    sendMessage(client, message);
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
}
