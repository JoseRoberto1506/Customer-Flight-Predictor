import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cfp_app/pages/cliente.dart';
import 'package:cfp_app/models/cliente_model.dart';

class AddPlanDialog extends StatefulWidget {
  const AddPlanDialog(
      {Key? key,
      required this.cliente,
      required this.clienteId,
      required this.onPlanAdded})
      : super(key: key);
  final Cliente cliente;
  final String? clienteId;
  final VoidCallback onPlanAdded;

  @override
  _AddPlanDialogState createState() => _AddPlanDialogState();
}

class _AddPlanDialogState extends State<AddPlanDialog> {
  String planName = '';
  List<String> tasks = [];
  final User? user = FirebaseAuth.instance.currentUser;
  final Map<String, dynamic>? planos = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cadastrar Plano'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Nome do Plano'),
            onChanged: (value) {
              setState(() {
                planName = value;
              });
            },
          ),
          SizedBox(height: 16),
          Text('Tarefas:'),
          Column(
            children: tasks.map((task) => Text(task)).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              _addTaskDialog(context, tasks);
            },
            child: Text('Adicionar Tarefa'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            await _salvarPlano(widget.clienteId);
            Navigator.of(context).pop(); // Close the dialog after saving
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }

  void _addTaskDialog(BuildContext context, List<String> tasks) {
    String newTask = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nova Tarefa'),
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
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  setState(() {
                    tasks.add(newTask);
                    print(tasks);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  _salvarPlano(String? clienteId) async {
    String? uid = user?.uid;
    CollectionReference listaPlanosRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('listaPlanos');

    Map<String, dynamic> plano = {
      'clienteId': clienteId,
      'nome': planName,
      'tarefas': tasks,
    };

    await listaPlanosRef.add(plano);
    widget.onPlanAdded();
  }
}
