// ignore_for_file: prefer_const_constructors

import 'package:cfp_app/pages/alterarPlano.dart';
import 'package:cfp_app/providers/plano_repository.dart';

import 'componentes/dialogConfirm.dart';
import 'package:cfp_app/pages/componentes/addPlanDialog.dart';
import 'package:cfp_app/pages/componentes/botao.dart';
import 'package:flutter/material.dart';
import 'package:cfp_app/models/pedido_model.dart';
import 'package:cfp_app/providers/pedidos_provider.dart';
import 'package:cfp_app/models/plano_acao_model.dart';
import 'package:cfp_app/models/cliente_model.dart';
import 'package:cfp_app/providers/clientes_provider.dart';


class TelaPedido extends StatefulWidget {
  final Pedido pedido;
  final String? pedidoId;
  final String? clienteId;

  const TelaPedido({
    Key? key,
    required this.pedido,
    required this.pedidoId,
    required this.clienteId,
  }) : super(key: key);

  @override
  State<TelaPedido> createState() => _TelaPedidoState();
}

class _TelaPedidoState extends State<TelaPedido> {
  late Future<Pedido> dadosPedidoFuture;
  late Future<List<PlanoAcao>> planosPedidoFuture;
  final PedidosProvider pedidoController = PedidosProvider();
  final PlanoAcaoRepository planoAcaoController = PlanoAcaoRepository();
  late Future<Cliente> dadosClienteFuture;
  final ClientesProvider clienteController = ClientesProvider();
  

  @override
  void initState() {
    super.initState();
    dadosPedidoFuture = pedidoController.getDadosPedido(widget.pedidoId);
    dadosClienteFuture = clienteController.getDadosCliente(widget.clienteId);
  }

  

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/lista_pedidos_servico');
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text('Dados do pedido'),
        backgroundColor: Color(0xFF313133),
      ),
      body: FutureBuilder(
        future: Future.wait([dadosPedidoFuture, dadosClienteFuture]),//planosClienteFuture
        builder: (context, snapshot,) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            Pedido? novoPedido = snapshot.data?[0] as Pedido?;
            Cliente? novoCliente = snapshot.data?[1] as Cliente?;
            
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    (novoPedido?.getTitulo() ?? 'Erro ao carregar'),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 350,
                      height: 500,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 71, 70, 70),
                        borderRadius: BorderRadius.circular(25),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              'CLIENTE: ${(novoCliente?.getNome() ?? '00000000000')}\n \n',
                              textAlign: TextAlign.center,
                              maxLines: 10,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'PROBLEMA: "${(novoPedido?.getDescricao() ?? '00000000000')}"\n \n',
                              textAlign: TextAlign.center,
                              maxLines: 10,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'DATA: ${(novoPedido?.getData() != null ? formatarData(novoPedido!.getData()) : 'Erro ao carregar')}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'HORA: ${(novoPedido?.getHora() != null ? formatarHora(novoPedido!.getHora()) : 'Erro ao carregar')}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\n STATUS DO SERVIÇO: ${(novoPedido?.getStatus() ?? '00000000')}',
                              textAlign: TextAlign.center,
                              maxLines: 10,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
            ),

            );
        }
        },

    ),
    );
  }
}

String formatarData (String data) {
  if (data.length != 8) {
    return 'Data inválida';
  }
  String dia = data.substring (0,2);
  String mes = data.substring (2,4);
  String ano = data.substring (4,8);

  return '$dia/$mes/$ano';
}

String formatarHora (String hora) {
  if (hora.length != 4) {
    return 'Hora inválida';
  }
  String horas = hora.substring (0,2);
  String minutos = hora.substring (2,4);

  return '$horas:$minutos';
}