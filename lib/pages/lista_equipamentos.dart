import 'package:cfp_app/pages/cadastrar_equipamentos.dart';
import 'package:cfp_app/pages/equipamentos.dart';
import 'package:flutter/material.dart';
import 'package:cfp_app/models/equipamentos_model.dart';
import 'package:cfp_app/providers/equipamentos_provider.dart';
import 'componentes/caixabonita.dart';
import 'componentes/dialogConfirm.dart';

class ListaEquipamentos extends StatefulWidget {
  const ListaEquipamentos({Key? key}) : super(key: key);

  @override
  ListaEquipamentosState createState() => ListaEquipamentosState();
}

class ListaEquipamentosState extends State<ListaEquipamentos> {
  final EquipamentosProvider equipamentosProvider = EquipamentosProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: equipamentosProvider.fetchEquipamentos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Enquanto os dados estão sendo buscados
        } else if (snapshot.hasError) {
          return const Text('Erro ao carregar dados'); // Se houver um erro
        } else {
          List<Equipamento> listaDeEquipamentos = snapshot.data as List<Equipamento>;
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
              title: const Text('Lista de Equipamentos'),
              backgroundColor: const Color(0xFF313133),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cadastrar_equipamentos');
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: equipamentosProvider.getQuantidadeEquipamentos(),
              itemBuilder: (context, i) {
                final equipamento = listaDeEquipamentos[i];
                final String? equipamentoId = equipamento.idEquipamento;

                return CaixaBonita(
                    filho: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaEquipamentos(
                          equipamento: equipamento,
                          equipamentoId: equipamentoId,
                        ),
                      ),
                    );
                  },
                  textColor: Colors.white,
                  title: Text(equipamento.nomeEquipamento),
                  subtitle: Text(equipamento.descricaoEquipamento),
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
                                    CadastrarEquipamento(equipamento: equipamento, equipamentoId: equipamentoId,),
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
                              'Tem certeza que deseja excluir este equipamento?',
                            );

                            if (deleteConfirmed == true) {
                              await equipamentosProvider
                                  .deletarEquipamento(equipamento.idEquipamento);
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  // Adicione mais widgets aqui para exibir outros detalhes do equipamento
                ));
              },
            ),
          );
        }
      },
    );
  }
}
