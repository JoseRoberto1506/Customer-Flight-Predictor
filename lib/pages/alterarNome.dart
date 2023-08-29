import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './componentes/campoForm.dart';
import './componentes/botao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaAlterarNomeUsuario extends StatefulWidget {
  const TelaAlterarNomeUsuario({super.key});

  @override
  State<TelaAlterarNomeUsuario> createState() => _TelaAlterarNomeUsuarioState();
}

class _TelaAlterarNomeUsuarioState extends State<TelaAlterarNomeUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _novoNomeUsuario = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 52),
                const Text(
                  'Customer Flight Predictor',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 70,
                ),
                const SizedBox(height: 70),
                CampoForm(
                  controller: _novoNomeUsuario,
                  obscureText: false,
                  icon: const Icon(Icons.person, color: Colors.white),
                  hintText: 'Digite o novo nome de usuário',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome de usuário';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 70),
                Botao(
                  fn: () {
                    if (_formKey.currentState!.validate()) {
                      String novoNome = _novoNomeUsuario.text;
                      alterarNomeUsuario(novoNome);
                      navegar(context, '/configuracoes');
                    }
                  },
                  texto: 'Alterar Nome',
                ),
                const SizedBox(height: 30),
                Botao(
                  fn: () => navegar(context, '/configuracoes'),
                  texto: 'Voltar',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navegar(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
  
  void alterarNomeUsuario(String novoNome) async {
  try {

    User? user = FirebaseAuth.instance.currentUser;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userRef = FirebaseFirestore.instance.collection('usuarios').doc(userId);

    await userRef.update({'username': novoNome});
    await user!.updateDisplayName(novoNome);

    print('Nome de usuário atualizado com sucesso');
  } catch (e) {
    print('Erro ao atualizar o nome de usuário: $e');
  }
  }
}
