import 'package:cfp_app/pages/cadastrar_cliente.dart';
import 'package:cfp_app/pages/cadastrar_pedido.dart';
import 'package:cfp_app/pages/cliente.dart';
import 'package:cfp_app/pages/pedido.dart';
import 'package:flutter/material.dart';
import 'componentes/dialogConfirm.dart';
import 'componentes/caixabonita.dart';
import 'package:cfp_app/models/pedido_model.dart';
import 'package:cfp_app/providers/pedidos_provider.dart';

class ListaPedidosServico extends StatefulWidget {
  const ListaPedidosServico({Key? key}) : super(key: key);

  @override
  _ListaPedidosServicoState createState() => _ListaPedidosServicoState();
}

class _ListaPedidosServicoState extends State<ListaPedidosServico> {
  final PedidosProvider pedidoController = PedidosProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pedidoController.fetchPedidos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // While data is being fetched
        } else if (snapshot.hasError) {
          return const Text('Error loading data'); // If there's an error
        } else {
          List<Pedido> listaDePedidos = snapshot.data as List<Pedido>;
          return Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back_sharp),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/menu');
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              title: const Text('Lista de pedidos'),
              backgroundColor: const Color(0xFF313133),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cadastrar_pedido');
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: pedidoController.getQuantidadePedidos(),
              itemBuilder: (context, i) {
                final pedido = listaDePedidos[i];
                final String? pedidoId = pedido.idPedido;

                return CaixaBonita(
                    filho: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaPedido(
                                pedido: pedido,
                                pedidoId: pedidoId,
                              )),
                    );
                  },
                  textColor: Colors.white,
                  title: Text('${pedido.getTitulo()}'), //interpolação de string
                  subtitle: Text(pedido.getStatus()),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TelaCadastrarPedido(pedido: pedido),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () async {
                            bool? deleteConfirmed =
                                await ConfirmationDialog.show(
                              context,
                              'Confirmação',
                              'Tem certeza que deseja excluir este pedido?',
                            );

                            if (deleteConfirmed == true) {
                              await pedidoController
                                  .deletarPedido(pedido.idPedido);
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  // Add more widgets here to display other client details
                ));
              },
            ),
          );
        }
      },
    );
  }
}
