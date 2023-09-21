import 'package:cfp_app/pages/adicionar_feedback.dart';
import 'package:cfp_app/pages/alterarPlano.dart';
import 'package:cfp_app/providers/plano_repository.dart';

import 'componentes/dialogConfirm.dart';
import 'package:cfp_app/pages/componentes/addPlanDialog.dart';
import 'package:cfp_app/pages/componentes/botao.dart';
import 'package:flutter/material.dart';
import 'package:cfp_app/models/cliente_model.dart';
import 'package:cfp_app/providers/clientes_provider.dart';
import 'package:cfp_app/models/plano_acao_model.dart';

class TelaCliente extends StatefulWidget {
  final Cliente cliente;
  final String? clienteId;

  const TelaCliente({
    Key? key,
    required this.cliente,
    required this.clienteId,
  }) : super(key: key);

  @override
  State<TelaCliente> createState() => _TelaClienteState();
}

class _TelaClienteState extends State<TelaCliente> {
  late Future<Cliente> dadosClienteFuture;
  late Future<List<PlanoAcao>> planosClienteFuture;
  final ClientesProvider clienteController = ClientesProvider();
  final PlanoAcaoRepository planoAcaoController = PlanoAcaoRepository();

  @override
  void initState() {
    super.initState();
    dadosClienteFuture = clienteController.getDadosCliente(widget.clienteId);
    planosClienteFuture =
        planoAcaoController.getPlanosCliente(widget.clienteId);
  }

  void onPlanAdded() {
    setState(() {
      planosClienteFuture =
          planoAcaoController.getPlanosCliente(widget.clienteId);
    });
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
                Navigator.pushReplacementNamed(context, '/lista_clientes');
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text('Dados do cliente'),
        backgroundColor: const Color(0xFF313133),
      ),
      body: FutureBuilder(
        future: Future.wait([dadosClienteFuture, planosClienteFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            Cliente? novoCliente = snapshot.data?[0] as Cliente?;
            List<PlanoAcao> planosCliente =
                snapshot.data?[1] as List<PlanoAcao>;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 52,
                  ),
                  Text(
                    (novoCliente?.getNome() ?? 'Erro ao carregar'),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(
                    height: 52,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 350,
                      height: 250,
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
                              'CPF: ${(novoCliente?.getCPF() ?? '00000000000')}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Data de nascimento: ${(novoCliente?.getDataNasc() ?? '00000000')}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Sexo: ${(novoCliente?.getSexo() ?? 'Erro ao carregar')}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Churn: ${(novoCliente?.getChanceChurn() ?? 'Erro ao carregar')}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Botao(
                                fn: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddPlanDialog(
                                        clienteId: widget.clienteId,
                                        onPlanAdded: onPlanAdded,
                                      );
                                    },
                                  );
                                },
                                texto: 'Cadastrar Plano'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Display plans
                  if (planosCliente.isNotEmpty)
                    Column(
                      children: [
                        const Text(
                          'Planos:',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: planosCliente.map((plano) {
                              return Card(
                                color: Colors.grey[800],
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        plano.nome,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: plano.tarefas
                                            .asMap()
                                            .entries
                                            .map<Widget>((entry) {
                                          final index = entry.key;
                                          final tarefa = entry.value;
                                          return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16),
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value: tarefa.isComplete,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        tarefa.isComplete =
                                                            newValue ?? false;
                                                      });
                                                      planoAcaoController
                                                          .atualizarStatusTarefa(
                                                              plano, tarefa);
                                                    },
                                                  ),
                                                  Expanded(
                                                    child: Tooltip(
                                                      message:
                                                          tarefa.tituloTarefa,
                                                      child: Text(
                                                        tarefa.tituloTarefa,
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                          color: Colors
                                                              .lightBlueAccent,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                        }).toList(),
                                      ),
                                      trailing: SizedBox(
                                        width: 100,
                                        height: 180,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            width: 200,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              TelaAlterarPlano(
                                                            plano: plano,
                                                            cliente:
                                                                widget.cliente,
                                                          ),
                                                        ));
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                  color: Colors.white,
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    bool? deletedConfirmed =
                                                        await ConfirmationDialog
                                                            .show(
                                                      context,
                                                      'Confirmação',
                                                      'Tem certeza que deseja excluir este plano?',
                                                    );
                                                    if (deletedConfirmed ==
                                                        true) {
                                                      await planoAcaoController
                                                          .deletarPlano(
                                                              plano.nome);
                                                      onPlanAdded();
                                                      planosClienteFuture =
                                                          planoAcaoController
                                                              .getPlanosCliente(
                                                                  widget
                                                                      .clienteId);
                                                    }
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Botao(
                      fn: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaAdicionarFeedback(
                              cpfCliente: widget.cliente.cpfCliente,
                            ),
                          ),
                        );
                      },
                      texto: "Adicionar Feedback",
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
