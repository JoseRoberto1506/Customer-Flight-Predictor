// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:cfp_app/pages/componentes/dialogConfirm.dart';
import 'package:flutter/material.dart';
import './componentes/campoForm.dart';
import './componentes/botao.dart';
import './componentes/dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/models/cliente_model.dart';

class TelaCadastrarCliente extends StatefulWidget {
  final Cliente? cliente;
  final String? clienteId;
  const TelaCadastrarCliente({Key? key, this.cliente, this.clienteId}) : super(key: key);

  @override
  State<TelaCadastrarCliente> createState() => _TelaCadastrarCliente();
}

class _TelaCadastrarCliente extends State<TelaCadastrarCliente> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeCliente;
  late final TextEditingController _cpfCliente;
  late final TextEditingController _nascimentoCliente;
  late final TextEditingController _sexoCliente;
  late final TextEditingController _pChurnCliente;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nomeCliente = TextEditingController();
    _cpfCliente = TextEditingController();
    _nascimentoCliente = TextEditingController();
    _sexoCliente = TextEditingController();
    _pChurnCliente = TextEditingController();
        if (widget.cliente != null){
      _nomeCliente.text = widget.cliente!.nomeCliente;
      _cpfCliente.text = widget.cliente!.cpfCliente;
      _nascimentoCliente.text = widget.cliente!.dataNascCliente;
      _sexoCliente.text = widget.cliente!.sexoCliente;
      _pChurnCliente.text = widget.cliente!.chanceChurn;

    }
  }

  Future<void> cadastrarcliente() async {
    if (_formKey.currentState!.validate()) {
      final cliente = Cliente(
          idCliente: widget.cliente?.idCliente ?? '',
          nomeCliente: _nomeCliente.text,
          cpfCliente: _cpfCliente.text,
          dataNascCliente: _nascimentoCliente.text,
          sexoCliente: _sexoCliente.text,
          chanceChurn: _pChurnCliente.text);
      final Map<String, dynamic> clienteJson = cliente.toJson();

      String? uid = user?.uid;
      DocumentReference userDocRef = db.collection('usuarios').doc(uid);
      CollectionReference listaClientesRef =
          userDocRef.collection('listaclientes');
          if (widget.cliente == null){
            DocumentReference novoCliente = await listaClientesRef.add(clienteJson);
            String idNovoCliente = novoCliente.id;
            clienteJson['idCliente'] = idNovoCliente;
            await novoCliente.update({'idCliente': idNovoCliente});
          } else{
            
              await listaClientesRef.doc(cliente.idCliente).update(clienteJson);
              print('cliente existente atualizado ');

            
          }





      bool? confirmado = await ConfirmationDialog.show(
        context,
        'Cadastro Confirmado',
        'Deseja cadastrar um novo cliente?',
      );
      if (confirmado == true) {
        _nomeCliente.clear();
        _cpfCliente.clear();
        _nascimentoCliente.clear();
        _sexoCliente.clear();
        _pChurnCliente.clear();
      } else {
        navegar(context, '/lista_clientes');
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
      key: _formKey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 52,
            ),
            const Text(
              'Cadastrar cliente',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 52,
            ),
            CampoForm(
                controller: _nomeCliente,
                obscureText: false,
                hintText: 'Nome completo',
                icon: const Icon(Icons.person, color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                }),
            const SizedBox(
              height: 20,
            ),
            CampoForm(
              controller: _cpfCliente,
              obscureText: false,
              hintText: 'CPF',
              icon: const Icon(Icons.person, color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'campo obrigatório';
                } else if (!isNumeric(value) || value.length != 11) {
                  return 'cpf inválido';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CampoForm(
              controller: _nascimentoCliente,
              obscureText: false,
              hintText: 'Data de nascimento',
              icon: const Icon(Icons.calendar_month, color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                } else if (!isNumeric(value) || value.length != 8) {
                  return 'Data de nascimento inválida';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Dropdown(
              controller: _sexoCliente,
              dropOpcoes: ['Masculino', 'Feminino'],
              hint: 'Sexo',
              icon: Icon(Icons.directions_run_outlined, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Dropdown(
              controller: _pChurnCliente,
              dropOpcoes: ['Grande chance de sair', 'Pouca chance de sair'],
              hint: 'Probabilidade de Churn',
              icon: Icon(Icons.directions_run_outlined, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Botao(fn: cadastrarcliente, texto: "Cadastrar"),
            const SizedBox(
              height: 20,
            ),
            Botao(
                fn: () => navegar(context, '/lista_clientes'), texto: "Voltar"),
          ],
        ),
      ),
    )));
  }

  bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  void navegar(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
