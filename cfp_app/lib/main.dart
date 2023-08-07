import 'package:flutter/material.dart';
import './pages/login.dart';
import './pages/cadastro.dart';
import './pages/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer Flight Predictor',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF141414),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF50c878),
        )
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => const TelaLogin(),
        '/cadastro': (context) => const TelaCadastro(),
        '/home': (context) => const TelaHome(),
      },
    );
  }
}
