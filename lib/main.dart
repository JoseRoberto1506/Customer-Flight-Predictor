import 'package:cfp_app/pages/equipamentos.dart';
import 'package:cfp_app/pages/lista_clientes.dart';
import 'package:cfp_app/pages/lista_equipamentos.dart';
import 'package:cfp_app/pages/sobre_app.dart';
import 'package:flutter/material.dart';
import './pages/login.dart';
import './pages/cadastro.dart';
import './pages/cadastrar_cliente.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import './pages/menu.dart';
import './pages/config.dart';
import './pages/alterarSenha.dart';
import './pages/alterarNome.dart';
import './pages/alterarPlano.dart';
import 'pages/cadastrar_equipamentos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Customer Flight Predictor",
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF242425),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xFF0EA5B0),
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Colors.red,
          )),
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaLogin(),
        '/cadastro': (context) => const TelaCadastro(),
        '/cadastrar_cliente': (context) => const TelaCadastrarCliente(),
        '/menu': (context) => const TelaMenu(),
        '/lista_clientes': (context) => const ListaClientes(),
        '/configuracoes':(context)=> const TelaConfiguracoes(),
        '/sobre':(context) => const TelaSobreAPP(),
        '/senha': (context) => const TelaAlterarSenha(),
        '/nome' : (context) => const TelaAlterarNomeUsuario(),
        '/lista_equipamentos' : (context) => const ListaEquipamentos(),
        '/cadastrar_equipamentos' : (context) => const CadastrarEquipamento(),
        
      },
    );
  }
}
