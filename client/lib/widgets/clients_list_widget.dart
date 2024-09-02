import 'package:flutter/material.dart';

import '../models/client_model.dart';

class ClientsListWidget extends StatelessWidget {
  const ClientsListWidget({
    super.key,
    required this.selectedIndex,
    required this.clients,
    required this.onChangeSelectedClientIndex,
  });

  final int selectedIndex;
  final List<ClientModel> clients;
  final ValueChanged<int> onChangeSelectedClientIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
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
            selected: index == selectedIndex,
            selectedTileColor: Theme.of(context).colorScheme.primary,
            selectedColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => onChangeSelectedClientIndex(index),
            title: Text(clients[index].name),
          );
        },
      ),
    );
  }
}
