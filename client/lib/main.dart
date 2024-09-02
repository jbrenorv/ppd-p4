import 'package:client/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/create_client_page.dart';

void main() {
  runApp(const ClientApp());
}

class ClientApp extends StatelessWidget {
  const ClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: false).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24.0),
          )
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
        )
      ),
      home: FutureBuilder(
        future: _getClientName(),
        builder: (context, snapshot) {
          final clientName = snapshot.data;
          if (clientName == null) {
            return const CreateClientPage();
          }
          return HomePage(clientName: clientName);
        },
      ),
    );
  }

  Future<String?> _getClientName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('client_name');
  }
}
