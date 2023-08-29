import 'package:cfp_app/pages/componentes/caixabonita.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'componentes/botao.dart';
import 'componentes/campoForm.dart';

class TelaAlterarPlano extends StatefulWidget {
  @override
  _TelaAlterarPlanoState createState() => _TelaAlterarPlanoState();
}

class _TelaAlterarPlanoState extends State<TelaAlterarPlano> {
  late Map<String, dynamic> planData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _planNameController = TextEditingController();
  List<String> updatedTasks = [];
  Map<String, TextEditingController> _taskControllers = {};

  @override
  void initState() {
    super.initState();
    // Avoid accessing inherited widgets here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    planData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _planNameController.text = planData['nome'] ?? '';
    updatedTasks = List<String>.from(planData['tarefas']);
    for (String task in planData['tarefas']) {
      _taskControllers[task] = TextEditingController(text: task);
    }
  }

  List<String> _getUpdatedTasks() {
    return updatedTasks;
  }

  void _updateTaskControllerValue(String task, String value) {
    _taskControllers[task]!.text = value;
  }

  void _saveChanges() async {
    try {
      if (_formKey.currentState!.validate()) {
        User? user = FirebaseAuth.instance.currentUser;
        String? uid = user?.uid;
        List<String> updatedTasks = [];
        for (String task in _taskControllers.keys) {
          updatedTasks.add(_taskControllers[task]!.text);
        }
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('listaPlanos')
            .doc(planData['id'])
            .update({
          'tarefas': updatedTasks,
        });
        print(updatedTasks);
      }
    } catch (error) {
      print('error$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Plano'),
        backgroundColor: Color(0xFF313133),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Plan name editing field
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CaixaBonita(
                  filho: TextFormField(
                    controller: _planNameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Nome do Plano',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a plan name.';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              // Other editing fields
              // ...

              // Generate a list of TextFormField widgets for tasks
              for (String task in planData['tarefas'])
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CampoForm(
                      controller: _taskControllers[task]!,
                      obscureText: false,
                      hintText: 'Task',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor digite uma tarefa.';
                        }
                        return null;
                      },
                      icon: Icon(Icons.task_outlined),
                    ),
                  ),
                ),
              const SizedBox(
                height: 50,
              ),

              // Save button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Botao(
                  fn: _saveChanges,
                  texto: 'Salvar',

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
