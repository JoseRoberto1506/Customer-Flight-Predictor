import 'package:flutter/material.dart';
import 'package:cfp_app/models/compromisso_model.dart';
import 'package:cfp_app/providers/compromisso_repository.dart';
import 'package:cfp_app/pages/componentes/dado_compromisso.dart';

class TelaCompromisso extends StatefulWidget {
  final Compromisso compromisso;
  final String? idCompromisso;

  const TelaCompromisso({
    Key? key,
    required this.compromisso,
    required this.idCompromisso,
  }) : super(key: key);

  @override
  State<TelaCompromisso> createState() => _TelaCompromissoState();
}

class _TelaCompromissoState extends State<TelaCompromisso> {
  final CompromissosRepository compromissoController = CompromissosRepository();
  late Future<Compromisso> dadosCompromissoFuture;

  @override
  void initState() {
    super.initState();
    dadosCompromissoFuture =
        compromissoController.getDadosCompromisso(widget.idCompromisso);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/lista_compromissos');
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text('Dados do Compromisso'),
        centerTitle: true,
        backgroundColor: const Color(0xFF313133),
      ),
      body: FutureBuilder(
        future: dadosCompromissoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text('Você não tem compromissos cadastrados'));
          } else {
            Compromisso compromisso = snapshot.data as Compromisso;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 52,
                  ),
                  Text(
                    compromisso.getNomeCompromisso(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 350,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 71, 70, 70),
                        borderRadius: BorderRadius.circular(25),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DadoDoCompromisso(
                                titulo: 'Tema: ',
                                conteudo: compromisso.getTemaCompromisso()),
                            const SizedBox(height: 4),
                            DadoDoCompromisso(
                                titulo: 'Local: ',
                                conteudo: compromisso.getLocalCompromisso()),
                            const SizedBox(height: 4),
                            DadoDoCompromisso(
                                titulo: 'Data: ',
                                conteudo: compromisso.getDataCompromisso()),
                            const SizedBox(height: 4),
                            DadoDoCompromisso(
                                titulo: 'Hora: ',
                                conteudo: compromisso.getHoraCompromisso()),
                            const SizedBox(height: 4),
                            DadoDoCompromisso(
                                titulo: 'Desc.: ',
                                conteudo:
                                    compromisso.getDescricaoCompromisso()),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
