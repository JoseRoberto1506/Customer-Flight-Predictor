import 'package:flutter/material.dart';
import 'package:cfp_app/models/compromisso_model.dart';
import 'package:cfp_app/providers/compromisso_repository.dart';
import 'package:cfp_app/pages/componentes/caixabonita.dart';
import 'package:cfp_app/pages/compromisso.dart';
import 'package:cfp_app/pages/cadastrar_compromisso.dart';
import 'package:cfp_app/pages/componentes/dialogConfirm.dart';

class ListaCompromissos extends StatefulWidget {
  const ListaCompromissos({Key? key}) : super(key: key);

  @override
  State<ListaCompromissos> createState() => _ListaCompromissosState();
}

class _ListaCompromissosState extends State<ListaCompromissos> {
  final CompromissosRepository compromissoController = CompromissosRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: compromissoController.getCompromissos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading data');
        } else {
          List<Compromisso> listaDeCompromissos =
              snapshot.data as List<Compromisso>;
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
              title: const Text('Lista de Compromissos'),
              centerTitle: true,
              backgroundColor: const Color(0xFF313133),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cadastrar_compromisso');
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: compromissoController.getQuantidadeCompromissos(),
              itemBuilder: (context, i) {
                final compromisso = listaDeCompromissos[i];
                final String? compromissoId = compromisso.idCompromisso;

                return CaixaBonita(
                    filho: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaCompromisso(
                                compromisso: compromisso,
                                idCompromisso: compromissoId,
                              )),
                    );
                  },
                  textColor: Colors.white,
                  title: Text(compromisso.getNomeCompromisso()),
                  subtitle: Flexible(
                      child: Wrap(
                          children: [Text(compromisso.getTemaCompromisso())])),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaCadastrarCompromisso(
                                    compromisso: compromisso),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.white,
                          onPressed: () async {
                            bool? deleteConfirmed =
                                await ConfirmationDialog.show(
                              context,
                              'Confirmação',
                              'Tem certeza que deseja excluir este compromisso?',
                            );

                            if (deleteConfirmed == true) {
                              await compromissoController.deletarCompromisso(
                                  compromisso.idCompromisso);
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ));
              },
            ),
          );
        }
      },
    );
  }
}
