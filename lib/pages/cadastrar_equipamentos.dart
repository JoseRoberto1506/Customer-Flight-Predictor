import 'package:flutter/material.dart';
import 'package:cfp_app/models/equipamentos_model.dart';
import 'package:cfp_app/pages/componentes/campoForm.dart';
import 'package:cfp_app/pages/componentes/dialogConfirm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './componentes/botao.dart';

class CadastrarEquipamento extends StatefulWidget {
  final Equipamento? equipamento;
  final String? equipamentoId;

  const CadastrarEquipamento({Key? key, this.equipamento, this.equipamentoId})
      : super(key: key);

  @override
  State<CadastrarEquipamento> createState() => _CadastrarEquipamentoState();
}

class _CadastrarEquipamentoState extends State<CadastrarEquipamento> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeEquipamento;
  late final TextEditingController _descricaoEquipamento;
  late final TextEditingController _precoEquipamento;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nomeEquipamento = TextEditingController();
    _descricaoEquipamento = TextEditingController();
    _precoEquipamento = TextEditingController();

    if (widget.equipamento != null) {
      _nomeEquipamento.text = widget.equipamento!.nomeEquipamento;
      _descricaoEquipamento.text = widget.equipamento!.descricaoEquipamento;
      _precoEquipamento.text = widget.equipamento!.precoEquipamento.toStringAsFixed(2);
    }
  }

  Future<void> cadastrarEquipamento() async {
    if (_formKey.currentState!.validate()) {
      final equipamento = Equipamento(
        idEquipamento: widget.equipamento?.idEquipamento ?? '',
        nomeEquipamento: _nomeEquipamento.text,
        descricaoEquipamento: _descricaoEquipamento.text,
        precoEquipamento: double.parse(_precoEquipamento.text),
      );

      final Map<String, dynamic> equipamentoJson = equipamento.toJson();

      String? uid = user?.uid;
      DocumentReference userDocRef = db.collection('usuarios').doc(uid);
      CollectionReference equipamentosRef =
          userDocRef.collection('equipamentos');

      if (widget.equipamento == null) {
        DocumentReference novoEquipamento =
            await equipamentosRef.add(equipamentoJson);
        String idNovoEquipamento = novoEquipamento.id;
        equipamentoJson['idEquipamento'] = idNovoEquipamento;
        await novoEquipamento.update({'idEquipamento': idNovoEquipamento});
      } else {
        await equipamentosRef.doc(equipamento.idEquipamento).update(equipamentoJson);
        print('Equipamento existente atualizado');
      }

      bool? confirmado = await ConfirmationDialog.show(
        context,
        'Cadastro Confirmado',
        'Deseja cadastrar um novo equipamento?',
      );

      if (confirmado == true) {
        _nomeEquipamento.clear();
        _descricaoEquipamento.clear();
        _precoEquipamento.clear();
      } else {
        navegar(context, '/lista_equipamentos');
      }
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
              const Text(
                'Cadastrar Equipamento',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 52,
              ),
              CampoForm(
                controller: _nomeEquipamento,
                obscureText: false,
                hintText: 'Nome do Equipamento',
                icon: const Icon(Icons.build, color: Colors.white),
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
                controller: _descricaoEquipamento,
                obscureText: false,
                hintText: 'Descrição do Equipamento',
                icon: const Icon(Icons.description, color: Colors.white),
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
                controller: _precoEquipamento,
                obscureText: false,
                hintText: 'Preço do Equipamento',
                icon: const Icon(Icons.attach_money, color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (!isNumeric(value)) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Botao(fn: cadastrarEquipamento, texto: "Cadastrar"),
              const SizedBox(
                height: 20,
              ),
              Botao(
                  fn: () => navegar(context, '/lista_equipamentos'),
                  texto: "Voltar"),
            ],
          ),
        ),
      ),
    ),
  );
}

bool isNumeric(String value) {
  return double.tryParse(value) != null;
}

void navegar(BuildContext context, String routeName) {
  Navigator.pushReplacementNamed(context, routeName);
}
}