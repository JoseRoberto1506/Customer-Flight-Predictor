import 'package:cfp_app/pages/componentes/botao.dart';
import 'package:cfp_app/providers/feedback_repository.dart';
import 'package:flutter/material.dart';

import 'package:cfp_app/models/feedback_model.dart';
import 'Controller/feedback_controller.dart';

import 'componentes/dialogConfirm.dart';

class TelaAdicionarFeedback extends StatefulWidget {
  final String cpfCliente;
  final FeedbackCliente? feedbackCliente;

  const TelaAdicionarFeedback({required this.cpfCliente, this.feedbackCliente});

  @override
  TelaAdicionarFeedbackState createState() => TelaAdicionarFeedbackState();
}

class TelaAdicionarFeedbackState extends State<TelaAdicionarFeedback> {
  DateTime _selectedDate = DateTime.now();
  String _selectedSatisfacao = '0 - Não Informado';
  final TextEditingController _comentarioController = TextEditingController();
  final FeedbackProvider _feedbackProvider = FeedbackProvider();
  late FeedbackController _feedbackController =
      FeedbackController(_feedbackProvider);

  List<String> satisfacaoOptions = [
    '0 - Não Informado',
    '1 - Muito Insatisfeito',
    '2 - Insatisfeito',
    '3 - Indiferente',
    '4 - Satisfeito',
    '5 - Muito Satisfeito',
  ];

  FeedbackCliente criarFeedbackCliente() {
    return FeedbackCliente(
      clienteCpf: widget.cpfCliente,
      dataFeedback: _selectedDate,
      satisfacaoFeedback: _selectedSatisfacao,
      comentarioFeedback: _comentarioController.text,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Verifique se o feedbackCliente foi fornecido para preencher os campos
    if (widget.feedbackCliente != null) {
      _selectedDate = widget.feedbackCliente!.dataFeedback;
      _selectedSatisfacao = widget.feedbackCliente!.satisfacaoFeedback;
      _comentarioController.text = widget.feedbackCliente!.comentarioFeedback;
    }
  }

  Future<void> _saveFeedback() async {
    if (_comentarioController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Campo de Comentário Vazio'),
            content: const Text(
                'Por favor, preencha o campo de comentário antes de salvar o feedback.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Impedir que a lógica de salvamento prossiga
    }
    FeedbackCliente feedbackCliente = criarFeedbackCliente();

    if (widget.feedbackCliente != null) {
      feedbackCliente.feedbackId = widget.feedbackCliente!.feedbackId;
      await _feedbackProvider.atualizarFeedback(feedbackCliente);
    } else {
      // Caso contrário, estamos adicionando um novo feedback
      await _feedbackController.cadastrarFeedback(feedbackCliente);
    }

    bool? confirmado = await ConfirmationDialog.show(
      context,
      'Cadastro Confirmado',
      'Deseja ir para lista de feedbacks?',
    );

    if (confirmado == true) {
      Navigator.pushReplacementNamed(context, '/lista_feedbacks');
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Feedback'),
        backgroundColor: const Color(0xFF313133),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Feedback',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Data do Feedback:',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            InkWell(
              onTap: () => _selectDate(context),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                  Text(
                    "${_selectedDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Satisfação no Atendimento:',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            DropdownButton<String>(
              value: _selectedSatisfacao,
              dropdownColor: Color(0xFF313133),
              items: satisfacaoOptions.map((String satisfacao) {
                return DropdownMenuItem<String>(
                  value: satisfacao,
                  child: Text(
                    satisfacao,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSatisfacao = newValue ?? '0 - Não Informado';
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Comentário:',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            TextFormField(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              controller: _comentarioController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Botao(
                fn: () async {
                  _saveFeedback();
                },
                texto: 'Salvar Feedback',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
