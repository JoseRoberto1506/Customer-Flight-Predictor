import 'package:cfp_app/pages/componentes/dropdown.dart';
import 'package:flutter/material.dart';
import './componentes/campoForm.dart';
import './componentes/botao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/models/promocao_model.dart';

class TelaCadastrarPromocao extends StatefulWidget {
  final Promocao? promocao;
  final String? clienteCpf;
  const TelaCadastrarPromocao({Key? key, this.promocao, this.clienteCpf}) : super(key: key);

  @override
  State<TelaCadastrarPromocao> createState() => _TelaCadastrarPromocao();
}

class _TelaCadastrarPromocao extends State<TelaCadastrarPromocao> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ClienteCpf;
  late final TextEditingController servico;
  late final TextEditingController _valor;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _ClienteCpf = TextEditingController();
    servico = TextEditingController();
    _valor = TextEditingController();
        if (widget.promocao != null){
      _ClienteCpf.text = widget.promocao!.clienteCpf;
      servico.text = widget.promocao!.servico;
      _valor.text = widget.promocao!.valor;
    }
  }

  Future<void> cadastrarpromocao() async {
    if (_formKey.currentState!.validate()) {
      final promocao = Promocao(
          id: widget.promocao?.id ?? '',
          clienteCpf: _ClienteCpf.text,
          servico: servico.text,
          valor: _valor.text);
      final Map<String, dynamic> promocaoJson = promocao.toJson();

      String? uid = user?.uid;
      DocumentReference userDocRef = db.collection('usuarios').doc(uid);
      CollectionReference listaPromocoesRef =
          userDocRef.collection('listapromocoes');
          if (widget.promocao == null){
            DocumentReference novaPromocao = await listaPromocoesRef.add(promocaoJson);
            String idNovaPromocao = novaPromocao.id;
            await novaPromocao.update({'id': idNovaPromocao});
          } else{
            
              await listaPromocoesRef.doc(promocao.id).update(promocaoJson);
              print('Promoção existente atualizado ');

            
          }
          navegar(context, '/lista_promocoes');
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
              'Cadastrar Promoção',
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
              controller: _ClienteCpf,
              obscureText: false,
              hintText: 'CPF',
              icon: const Icon(Icons.person, color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo Obrigatório';
                } else if (!isNumeric(value) || value.length != 11) {
                  return 'CPF inválido';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Dropdown(
              controller: servico,
              dropOpcoes: ['Internet: Cabo', 'Internet: Fibra Ótica', 'Internet: DSL', 'Streaming: Musica', 'Streaming: Filmes', 'Streaming: TV'],
              hint: 'Serviço',
              icon: Icon(Icons.archive, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            CampoForm(
              controller: _valor,
              obscureText: false,
              hintText: 'Valor do Desconto',
              icon: Icon(Icons.percent, color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }else if (!isNumeric(value)) {
                  return 'Valor inválido. Digite apenas valores numéricos';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Botao(fn: cadastrarpromocao, texto: "Cadastrar"),
            const SizedBox(
              height: 20,
            ),
            Botao(
                fn: () => navegar(context, '/lista_promocoes'), texto: "Voltar"),
          ],
        ),
      ),
    )));
  }

  bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  void navegar(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
