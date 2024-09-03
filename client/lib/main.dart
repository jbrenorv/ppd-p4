import 'package:flutter/material.dart';

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
      home: const CreateClientPage(),
    );
  }
}
