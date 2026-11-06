import 'package:flutter/material.dart';

import 'screens/busca_screen.dart';

void main() {
  runApp(const AppClima());
}

class AppClima extends StatelessWidget {
  const AppClima({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima Agora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const BuscaScreen(),
    );
  }
}
