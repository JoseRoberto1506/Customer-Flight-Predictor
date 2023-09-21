import 'package:cfp_app/models/plano_acao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cfp_app/models/tarefa_model.dart';
import 'package:cfp_app/providers/clientes_provider.dart';

class AddPlanDialog extends StatefulWidget {
  const AddPlanDialog(
      {Key? key, required this.clienteId, required this.onPlanAdded})
      : super(key: key);
  final String? clienteId;
  final VoidCallback onPlanAdded;

  @override
  AddPlanDialogState createState() => AddPlanDialogState();
}

class AddPlanDialogState extends State<AddPlanDialog> {
  String planName = '';
  List<Tarefa> tasks = [];
  final User? user = FirebaseAuth.instance.currentUser;
  final Map<String, dynamic>? planos = {};
  final ClientesProvider clienteController = ClientesProvider();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cadastrar Plano'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Nome do Plano'),
            onChanged: (value) {
              setState(() {
                planName = value;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text('Tarefas:'),
          Column(
            children: tasks.map((task) => Text(task.tituloTarefa)).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              _addTaskDialog(context, tasks);
            },
            child: const Text('Adicionar Tarefa'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            await _salvarPlano();
            Navigator.of(context).pop(); // Close the dialog after saving
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  void _addTaskDialog(BuildContext context, List<Tarefa> tasks) {
    String newTask = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nova Tarefa'),
                onChanged: (value) {
                  newTask = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  setState(() {
                    tasks.add(Tarefa(tituloTarefa: newTask));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  _salvarPlano() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;

      if (uid != null) {
        final PlanoAcao plano = PlanoAcao(
          clienteId: widget.clienteId,
          tarefas: tasks,
          nome: planName,
        );

        CollectionReference listaPlanosRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('listaPlanos');

        await listaPlanosRef.add(plano.toJson());
        widget.onPlanAdded(); // Feche o diálogo após salvar
      }
    } catch (e) {
      print('Erro ao salvar o plano: $e');
    }
  }
}
