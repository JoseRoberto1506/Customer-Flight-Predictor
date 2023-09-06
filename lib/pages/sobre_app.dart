import 'package:flutter/material.dart';
import 'componentes/botao.dart';

class TelaSobreAPP extends StatelessWidget {
  const TelaSobreAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 52),
            SizedBox(
              height: 102,
              width: 102,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(height: 25),
            const Text(
              'Sobre o APP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                  'De um modo geral, o sistema permite que a gestão de uma empresa de telecomunicações acompanhe a probabilidade de churn dos clientes cadastrados e as estratégias específicas idealizadas para a retenção de cada cliente propenso a sair. \n \nO objetivo do Customer Flight Predictor é fornecer aos usuários um sistema de fácil uso para o gerenciamento de clientes, permitindo cadastrá-los e visualizar seus dados, além de criar planos de ação personalizados para acompanhar as atividades necessárias para evitar o churn de determinado cliente.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Botao(
              fn: () => navegar(context, '/configuracoes'),
              texto: 'Voltar para Configurações',
            ),
          ],
        ),
      ),
    );
  }

  void navegar(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
