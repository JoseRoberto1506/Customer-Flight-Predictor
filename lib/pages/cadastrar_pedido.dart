// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:cfp_app/pages/componentes/dialogConfirm.dart';
import 'package:flutter/material.dart';
import './componentes/campoForm.dart';
import './componentes/botao.dart';
import 'componentes/dropdown_especial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/models/pedido_model.dart';
import 'package:cfp_app/providers/clientes_provider.dart';
import 'package:cfp_app/models/cliente_model.dart';

class TelaCadastrarPedido extends StatefulWidget {
  final Pedido? pedido;
  final String? pedidoId;
  const TelaCadastrarPedido({Key? key, this.pedido, this.pedidoId})
      : super(key: key);

  @override
  State<TelaCadastrarPedido> createState() => _TelaCadastrarPedido();
}

class _TelaCadastrarPedido extends State<TelaCadastrarPedido> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _data;
  late final TextEditingController _hora;
  late final TextEditingController _descricao;
  late final TextEditingController _nomecliente;
  final User? user = FirebaseAuth.instance.currentUser;
  final ClientesProvider clienteController = ClientesProvider();
  final ValueNotifier<Cliente?> _clienteSelecionado = ValueNotifier<Cliente?>(null);

  @override
  void initState() {
    super.initState();
    _data = TextEditingController();
    _hora = TextEditingController();
    _descricao = TextEditingController();
    _nomecliente = TextEditingController();
  }

  Future<void> cadastrarpedido() async {
    if (_formKey.currentState!.validate()) {
      final _clienteid =
          _clienteSelecionado.value?.idCliente ?? ''; // Inicialize _clienteid aqui

      final pedido = Pedido(
          idPedido: widget.pedido?.idPedido ?? '',
          data: _data.text,
          hora: _hora.text,
          descricao: _descricao.text,
          clienteId: _clienteid);
      final Map<String, dynamic> pedidoJson = pedido.toJson();

      String? uid = user?.uid;
      DocumentReference userDocRef = db.collection('usuarios').doc(uid);
      CollectionReference listaPedidosRef =
          userDocRef.collection('listapedidos');
      if (widget.pedido == null) {
        DocumentReference novoPedido = await listaPedidosRef.add(pedidoJson);
        String idNovoPedido = novoPedido.id;
        pedidoJson['idPedido'] = idNovoPedido;
        await novoPedido.update({'idPedido': idNovoPedido});
      } else {
        await listaPedidosRef.doc(pedido.idPedido).update(pedidoJson);
        print('pedido existente atualizado ');
      }

      bool? confirmado = await ConfirmationDialog.show(
        context,
        'Cadastro Confirmado',
        'Deseja cadastrar um novo pedido?',
      );
      if (confirmado == true) {
        _data.clear();
        _hora.clear();
        _descricao.clear();
      } else {
        navegar(context, '/lista_pedidos_servico');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: clienteController.fetchClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error loading data');
          } else {
            List<Cliente> listaDeClientes = snapshot.data as List<Cliente>;

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
                    DropdownEspecial(
                      dropValue:
                          _clienteSelecionado, // Use o ValueNotifier aqui
                      clienteSelecionado:
                          _clienteSelecionado, // Passe o ValueNotifier aqui
                      dropOpcoes: listaDeClientes,
                      hint: 'Selecione um cliente',
                      icon: Icon(Icons.directions_run_outlined,
                          color: Colors.white),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Cadastrar pedido',
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
                      controller: _data,
                      obscureText: false,
                      hintText: 'Data',
                      icon:
                          const Icon(Icons.calendar_month, color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!isNumeric(value) || value.length != 8) {
                          return 'Data de pedido inválida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CampoForm(
                      controller: _hora,
                      obscureText: false,
                      hintText: 'Hora',
                      icon: const Icon(Icons.access_time, color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!isNumeric(value) || value.length != 4) {
                          return 'Hora de pedido inválida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CampoForm(
                        longtext: true,
                        controller: _descricao,
                        obscureText: false,
                        hintText: 'Adicione uma descrição',
                        icon: const Icon(Icons.notes, color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 20,
                    ),

                    // Dropdown(
                    //   controller: _pChurnPedido,
                    //   dropOpcoes: ['Grande chance de sair', 'Pouca chance de sair'],
                    //   hint: 'Probabilidade de Churn',
                    //   icon: Icon(Icons.directions_run_outlined, color: Colors.white),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Botao(fn: cadastrarpedido, texto: "Cadastrar"),
                    const SizedBox(
                      height: 20,
                    ),
                    Botao(
                        fn: () => navegar(context, '/lista_pedidos_servico'),
                        texto: "Voltar"),
                  ],
                ),
              ),
            )));
          }
        });
  }

  bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  void navegar(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
