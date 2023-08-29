import 'package:flutter/material.dart';
import 'componentes/botao.dart';

class TelaSobreAPP extends StatelessWidget {
  const TelaSobreAPP({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            Container(
              padding: EdgeInsets.all(16.0),
              child: Image.asset('assets/images/logo.png', height: 200),
            ),
            Text(
              'Sobre o APP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'De um modo geral, o sistema permite que a gestão de uma empresa de telecomunicações acompanhe a probabilidade de churn dos clientes cadastrados e as estratégias específicas idealizadas para a retenção de cada cliente propenso a sair. \n \n O objetivo do Customer Flight Predictor é fornecer aos usuários um sistema de fácil uso para o gerenciamento de clientes, permitindo cadastrá-los e visualizar seus dados, além de criar planos de ação personalizados para acompanhar as atividades necessárias para evitar o churn de determinado cliente.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 18, color: Colors.white)
              
              ),
            ),
            SizedBox(height: 10),
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
