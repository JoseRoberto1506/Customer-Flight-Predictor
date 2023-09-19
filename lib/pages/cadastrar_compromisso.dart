import 'package:flutter/material.dart';
import 'package:cfp_app/models/compromisso_model.dart';
import './componentes/campoForm.dart';
import 'package:cfp_app/pages/componentes/campo_data_hora.dart';
import 'package:intl/intl.dart';
import './componentes/botao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/pages/componentes/dialogConfirm.dart';

class TelaCadastrarCompromisso extends StatefulWidget {
  final Compromisso? compromisso;
  const TelaCadastrarCompromisso({Key? key, this.compromisso})
      : super(key: key);

  @override
  State<TelaCadastrarCompromisso> createState() => _TelaCadastrarCompromisso();
}

class _TelaCadastrarCompromisso extends State<TelaCadastrarCompromisso> {
  String tituloTela = "";
  String textoBotao = "";
  final _formKey = GlobalKey<FormState>();
  late final _nomeCompromisso = TextEditingController();
  late final _temaCompromisso = TextEditingController();
  late final _localCompromisso = TextEditingController();
  late final _dataCompromisso = TextEditingController();
  late final _horaCompromisso = TextEditingController();
  late final _descricaoCompromisso = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.compromisso != null) {
      _nomeCompromisso.text = widget.compromisso!.compromisso;
      _temaCompromisso.text = widget.compromisso!.tema;
      _localCompromisso.text = widget.compromisso!.local;
      _dataCompromisso.text = widget.compromisso!.data;
      _horaCompromisso.text = widget.compromisso!.hora;
      _descricaoCompromisso.text = widget.compromisso!.hora;
      tituloTela = "Editar Compromisso";
      textoBotao = "Editar";
    } else {
      tituloTela = "Cadastrar Compromisso";
      textoBotao = "Cadastrar";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
      key: _formKey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 52,
            ),
            Text(
              tituloTela,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 52,
            ),
            CampoForm(
                controller: _nomeCompromisso,
                obscureText: false,
                hintText: 'Reunião, evento, palestra, ...',
                icon: const Icon(Icons.people_outlined, color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                }),
            const SizedBox(
              height: 20,
            ),
            CampoForm(
              controller: _temaCompromisso,
              obscureText: false,
              hintText: 'Conteúdo do compromisso',
              icon:
                  const Icon(Icons.content_copy_outlined, color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CampoForm(
              controller: _localCompromisso,
              obscureText: false,
              hintText: 'Local',
              icon: const Icon(Icons.location_on_outlined, color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CampoDataHora(
              controller: _dataCompromisso,
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              hintText: 'Data',
              onTap: () async {
                DateTime? dataSelecionada = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2102),
                );

                if (dataSelecionada != null) {
                  String dataFormatada =
                      DateFormat('dd-MM-yyyy').format(dataSelecionada);
                  setState(() {
                    _dataCompromisso.text = dataFormatada.toString();
                  });
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CampoDataHora(
              controller: _horaCompromisso,
              icon: const Icon(Icons.schedule_outlined, color: Colors.white),
              hintText: 'Hora',
              onTap: () async {
                TimeOfDay? horaSelecionada = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (horaSelecionada != null) {
                  setState(() {
                    _horaCompromisso.text =
                        "${horaSelecionada.hour}:${horaSelecionada.minute}";
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            CampoForm(
              controller: _descricaoCompromisso,
              obscureText: false,
              hintText: 'Descrição',
              icon: const Icon(Icons.description_outlined, color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Botao(fn: cadastrarCompromisso, texto: textoBotao),
            const SizedBox(
              height: 20,
            ),
            Botao(
                fn: () => navegar(context, '/lista_compromissos'),
                texto: "Voltar"),
          ],
        ),
      ),
    )));
  }

  void navegar(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  bool existeCompromisso() => widget.compromisso != null;

  Future<void> cadastrarCompromisso() async {
    if (_formKey.currentState!.validate()) {
      final compromisso = Compromisso(
        idCompromisso: widget.compromisso?.idCompromisso,
        compromisso: _nomeCompromisso.text,
        tema: _temaCompromisso.text,
        local: _localCompromisso.text,
        data: _dataCompromisso.text,
        hora: _horaCompromisso.text,
        descricao: _descricaoCompromisso.text,
      );
      final Map<String, dynamic> compromissoJson = compromisso.toJson();

      final User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('usuarios').doc(userId);
      CollectionReference listaCompromissosRef =
          userDocRef.collection('listaCompromissos');

      if (!existeCompromisso()) {
        DocumentReference novoCompromisso =
            await listaCompromissosRef.add(compromissoJson);
        String idNovoCompromisso = novoCompromisso.id;
        compromissoJson['idCompromisso'] = idNovoCompromisso;
        await novoCompromisso.update({'idCompromisso': idNovoCompromisso});
      } else {
        await listaCompromissosRef
            .doc(compromisso.idCompromisso)
            .update(compromissoJson);
      }

      if (!existeCompromisso()) {
        bool? confirmado = await ConfirmationDialog.show(
          context,
          'Compromisso cadastrado',
          'Deseja cadastrar um novo compromisso?',
        );
        if (confirmado == true) {
          _nomeCompromisso.clear();
          _temaCompromisso.clear();
          _localCompromisso.clear();
          _dataCompromisso.clear();
          _horaCompromisso.clear();
          _descricaoCompromisso.clear();
        } else {
          navegar(context, '/lista_compromissos');
        }
      } else {
        bool? confirmado = await ConfirmationDialog.show(
          context,
          'Compromisso editado',
          'Deseja editar o compromisso novamente?',
        );
        if (confirmado != true) {
          navegar(context, '/lista_compromissos');
        }
      }
    }
  }
}
