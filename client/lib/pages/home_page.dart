import 'package:client/models/client_model.dart';
import 'package:client/widgets/chat_widget.dart';
import 'package:client/widgets/clients_list_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.clientName});

  final String clientName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final _clients = <ClientModel>[
    ClientModel(
      name: 'joao',
    ),
    ClientModel(
      name: 'maressa',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ClientsListWidget(
              selectedIndex: _selectedIndex,
              onChangeSelectedClientIndex: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              clients: _clients,
            ),
          ),
          const VerticalDivider(
            width: 1.0,
          ),
          Expanded(
            flex: 2,
            child: ChatWidget(
              client: _clients[_selectedIndex],
              sendMessage: (client, message) {

              },
            ),
          ),
        ],
      ),
    );
  }
}
