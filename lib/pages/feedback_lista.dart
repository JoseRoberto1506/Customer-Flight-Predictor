import 'package:cfp_app/pages/adicionar_feedback.dart';
import 'componentes/filter_dialog.dart';

import 'package:cfp_app/providers/feedback_repository.dart';
import 'package:flutter/material.dart';
import 'Controller/feedback_controller.dart';
import 'componentes/dialogConfirm.dart';

import 'package:cfp_app/providers/clientes_provider.dart';
import 'package:cfp_app/models/feedback_model.dart';

class TelaListaFeedbacks extends StatefulWidget {
  const TelaListaFeedbacks({Key? key}) : super(key: key);

  @override
  _TelaListaFeedbacksState createState() => _TelaListaFeedbacksState();
}

class _TelaListaFeedbacksState extends State<TelaListaFeedbacks> {
  final FeedbackProvider _feedbackProvider = FeedbackProvider();
  late FeedbackController _feedbackController =
      FeedbackController(_feedbackProvider);
  final ClientesProvider clientesProvider = ClientesProvider();
  String _selectedFilter = 'CPF';
  String _searchValue = '';
  String _selectedSatisfacao = '0 - Não Informado';
  bool _filtroAplicado = false;

  final List<String> satisfactionOptions = [
    '0 - Não Informado',
    '1 - Muito Insatisfeito',
    '2 - Insatisfeito',
    '3 - Indiferente',
    '4 - Satisfeito',
    '5 - Muito Satisfeito',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _feedbackController.fetchFeedbacks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // While data is being fetched
        } else if (snapshot.hasError) {
          return const Text('Error loading data'); // If there's an error
        } else {
          List<FeedbackCliente> listaDeFeedbacks =
              snapshot.data as List<FeedbackCliente>;
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
              title: const Text('Lista de Feedbacks'),
              backgroundColor: const Color(0xFF313133),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: _feedbackProvider.getQuantidadeFeedbacks(),
              itemBuilder: (context, i) {
                final FeedbackCliente feedback = listaDeFeedbacks[i];
                //Verificar cpf
                final _cpfStartsWith =
                    feedback.clienteCpf.startsWith(_searchValue);
                //verificar satisfacao

                if (_filtroAplicado &&
                    (!_cpfStartsWith ||
                        (_selectedFilter == 'Satisfação' &&
                            feedback.satisfacaoFeedback !=
                                _selectedSatisfacao))) {
                  if (_selectedFilter == 'CPF' &&
                      feedback.clienteCpf != _searchValue) {
                    return Container(); // Não mostrar se não corresponder ao filtro CPF
                  } else if (_selectedFilter == 'Satisfação' &&
                      feedback.satisfacaoFeedback != _searchValue) {
                    return Container(); // Não mostrar se não corresponder ao filtro Satisfação
                  }
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.grey[800],
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey[800],
                              title: const Text(
                                'Comentário do Feedback',
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 16,
                                ),
                              ),
                              content: Text(
                                feedback.comentarioFeedback,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Fechar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      textColor: Colors.white,
                      title: Text(feedback.clienteCpf),
                      subtitle: Text(
                          'Data: ${feedback.dataFeedback.toString()} \n '
                          'Grau de Satisfação: ${feedback.getNotaSatisfacao()}'),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TelaAdicionarFeedback(
                                      cpfCliente: feedback.clienteCpf,
                                      feedbackCliente:
                                          feedback, // Passe o feedback
                                    ),
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
                                  'Tem certeza que deseja excluir este Feedback?',
                                );

                                if (deleteConfirmed == true) {
                                  await _feedbackController.deletarFeedback(
                                    context,
                                    feedback,
                                  );
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return FilterDialog(
          onFilterSelected: (filter) {
            final parts = filter.split('|');
            setState(() {
              _selectedFilter = parts[0];
              _searchValue = parts[1];
              _selectedSatisfacao = parts[2];
              _filtroAplicado = true; // Um filtro foi aplicado
              // Oculta o TextField quando "Satisfação" é selecionado
            });
          },
          satisfactionOptions: satisfactionOptions,
        );
      },
    );
  }
}
