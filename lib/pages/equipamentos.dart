import 'package:flutter/material.dart';
import 'package:cfp_app/models/equipamentos_model.dart';

class TelaEquipamentos extends StatelessWidget {
  final Equipamento equipamento;
  final String? equipamentoId;

  TelaEquipamentos({required this.equipamento, required this.equipamentoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Equipamento'),
        backgroundColor: Color.fromARGB(255, 13, 13, 14),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Nome: ${equipamento.nomeEquipamento}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Descrição: ${equipamento.descricaoEquipamento}',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Preço: R\$ ${equipamento.precoEquipamento.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Outros detalhes do equipamento, se necessário
            ],
          ),
        ),
      ),
    );
  }
}
