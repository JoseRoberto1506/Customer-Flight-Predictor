import 'package:flutter/material.dart';
import './pages/login.dart';
import './pages/cadastro.dart';
//import './pages/home.dart';

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
        scaffoldBackgroundColor: const Color(0xFF242425),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF0EA5B0),
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaLogin(),
        '/cadastro': (context) => const TelaCadastro(),
        
      },
    );
  }
}
