import 'package:cfp_app/models/cliente_model.dart';
import 'package:cfp_app/models/plano_acao_model.dart';
import 'package:cfp_app/models/tarefa_model.dart';
import 'package:cfp_app/pages/componentes/caixabonita.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'componentes/botao.dart';
import 'componentes/campoForm.dart';
import 'package:cfp_app/providers/plano_repository.dart';

class TelaAlterarPlano extends StatefulWidget {
  final PlanoAcao plano;
  final Cliente cliente;

  const TelaAlterarPlano({
    required this.plano,
    required this.cliente,
  });

  @override
  TelaAlterarPlanoState createState() => TelaAlterarPlanoState();
}

class TelaAlterarPlanoState extends State<TelaAlterarPlano> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _planNameController = TextEditingController();
  List<Tarefa> updatedTasks = [];
  Map<String, TextEditingController> _taskControllers = {};
  final PlanoAcaoRepository planoAcaoController = PlanoAcaoRepository();

  @override
  void initState() {
    super.initState();
    _planNameController.text = widget.plano.nome;
    updatedTasks = List<Tarefa>.from(widget.plano.tarefas);
    for (Tarefa task in widget.plano.tarefas) {
      _taskControllers[task.tituloTarefa] =
          TextEditingController(text: task.tituloTarefa);
    }
  }

  List<Tarefa> _getUpdatedTasks() {
    return updatedTasks;
  }

  void _saveChanges() async {
    try {
      if (_formKey.currentState!.validate()) {
        // Atualize as tarefas no Firebase
        String? idDoPlano =
            await planoAcaoController.getPlanoId(widget.plano.nome);
        final User? user = FirebaseAuth.instance.currentUser;
        final String? uid = user?.uid;

        if (idDoPlano != null && uid != null) {
          List<Map<String, dynamic>> updatedTarefas =
              widget.plano.tarefas.map((tarefa) {
            return {
              'tituloTarefa': _taskControllers[tarefa.tituloTarefa]!.text,
              'isComplete': tarefa.isComplete,
            };
          }).toList();

          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(uid)
              .collection('listaPlanos')
              .doc(idDoPlano)
              .update({
            'tarefas': updatedTarefas,
          });

          // Atualize as tarefas na instância do plano de ação
          widget.plano.tarefas.forEach((tarefa) {
            tarefa.tituloTarefa = _taskControllers[tarefa.tituloTarefa]!.text;
          });
          // Agora você pode atualizar o nome do plano de ação
          widget.plano.nome = _planNameController.text;
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(uid)
              .collection('listaPlanos')
              .doc(idDoPlano)
              .update({'nome': widget.plano.nome});

          setState(() {});
          Navigator.pop(context);
        } else {
          print('erro: cliente não encontrado');
        }
      }
    } catch (error) {
      print('error: $error');
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
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome para o plano.';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              // Generate a list of TextFormField widgets for tasks
              for (Tarefa task in widget.plano.tarefas)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _taskControllers[task.tituloTarefa] != null
                        ? CampoForm(
                            controller: _taskControllers[task.tituloTarefa]!,
                            obscureText: false,
                            hintText: 'Tarefa',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite uma tarefa.';
                              }
                              return null;
                            },
                            icon: Icon(Icons.task_outlined),
                          )
                        : Text("Controller is null"),
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
