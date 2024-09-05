import 'package:flutter/material.dart';

import '../models/client_model.dart';

class ClientsListWidget extends StatelessWidget {
  const ClientsListWidget({
    super.key,
    required this.connected,
    required this.client,
    required this.onChangeConected,
    required this.selectedClient,
    required this.clients,
    required this.onChangeSelectedClient,
  });

  final bool connected;
  final ClientModel client;
  final ClientModel? selectedClient;
  final List<ClientModel> clients;
  final ValueChanged<bool> onChangeConected;
  final ValueChanged<ClientModel> onChangeSelectedClient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.people),
        title: const Text('Usuários'),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('(${client.name}) ${connected ? "On" : "Off"}'),
              const SizedBox(width: 4.0),
              Switch(
                value: connected,
                onChanged: onChangeConected,
              ),
            ],
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: clients.length,
        separatorBuilder: (_, index) {
          return const Divider(
            height: 1.0,
          );
        },
        itemBuilder: (_, index) {
          return ListTile(
            selected: clients[index] == selectedClient,
            selectedTileColor: Theme.of(context).colorScheme.primary,
            selectedColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => onChangeSelectedClient(clients[index]),
            title: Text(clients[index].name),
          );
        },
      ),
    );
  }
}
