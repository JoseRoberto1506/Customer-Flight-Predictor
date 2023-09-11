import 'package:cfp_app/pages/cadastrar_cliente.dart';
import 'package:cfp_app/pages/cliente.dart';
import 'package:flutter/material.dart';
import 'componentes/dialogConfirm.dart';
import 'componentes/caixabonita.dart';
import 'package:cfp_app/models/cliente_model.dart';
import 'package:cfp_app/providers/clientes_provider.dart';

class ListaClientes extends StatefulWidget {
  const ListaClientes({Key? key}) : super(key: key);

  @override
  _ListaClientesState createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {
  final ClientesProvider clienteController = ClientesProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: clienteController.fetchClients(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // While data is being fetched
        } else if (snapshot.hasError) {
          return const Text('Error loading data'); // If there's an error
        } else {
          List<Cliente> listaDeClientes = snapshot.data as List<Cliente>;
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
              title: const Text('Lista de clientes'),
              backgroundColor: const Color(0xFF313133),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cadastrar_cliente');
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: clienteController.getQuantidadeClientes(),
              itemBuilder: (context, i) {
                final cliente = listaDeClientes[i];
                final String? clienteId = cliente.idCliente;

                return CaixaBonita(
                    filho: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaCliente(
                                cliente: cliente,
                                clienteId: clienteId,
                              )),
                    );
                  },
                  textColor: Colors.white,
                  title: Text(cliente.getNome()),
                  subtitle: Text(cliente.getCPF()),
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
                                    TelaCadastrarCliente(cliente: cliente),
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
                              'Tem certeza que deseja excluir este cliente?',
                            );

                            if (deleteConfirmed == true) {
                              await clienteController
                                  .deletarCliente(cliente.idCliente);
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
