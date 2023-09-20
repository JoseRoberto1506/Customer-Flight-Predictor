import 'package:cfp_app/models/promocao_model.dart';
import 'package:cfp_app/pages/cadastrar_promocao.dart';
import 'package:flutter/material.dart';
import 'componentes/dialogConfirm.dart';
import 'componentes/caixabonita.dart';
import 'package:cfp_app/providers/promocoes_provider.dart';

class ListaPromocoes extends StatefulWidget {
  const ListaPromocoes({Key? key}) : super(key: key);

  @override
  _ListaPromocoesState createState() => _ListaPromocoesState();
}

class _ListaPromocoesState extends State<ListaPromocoes> {
  final PromocoesProvider promocaoController = PromocoesProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: promocaoController.fetchPromocoes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // While data is being fetched
        } else if (snapshot.hasError) {
          return const Text('Error loading data'); // If there's an error
        } else {
          List<Promocao> listaDePromocoes = snapshot.data as List<Promocao>;
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
              title: const Text('Lista de Promoções'),
              centerTitle: true,
              backgroundColor: const Color(0xFF313133),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cadastrar_promocao');
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: promocaoController.getQuantidadePromocoes(),
              itemBuilder: (context, i) {
                final promocao = listaDePromocoes[i];
                final String? id = promocao.id;

                return CaixaBonita(
                    filho: ListTile(
                  textColor: Colors.white,
                  title: Text('CPF do Cliente: ${promocao.getCPF()}'),
                  subtitle: Text('Serviço: ${promocao.getServico()}\nValor: ${promocao.getValor()}%'),
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
                                    TelaCadastrarPromocao(promocao: promocao), 
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
                              'Tem certeza que deseja excluir esta Promoção?',
                            );

                            if (deleteConfirmed == true) {
                              await promocaoController
                                  .deletarPromocao(promocao.id);
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.white,
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

