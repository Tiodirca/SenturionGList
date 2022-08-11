import 'package:flutter/material.dart';

import '../Modelo/TabelaModelo.dart';
import '../Uteis/Servicos/banco_de_dados.dart';
import '../Uteis/constantes.dart';
import '../Uteis/estilo.dart';
import '../Uteis/textos.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaSelecaoEscala extends StatefulWidget {
  const TelaSelecaoEscala({
    Key? key,
  }) : super(key: key);

  @override
  State<TelaSelecaoEscala> createState() => _TelaSelecaoEscalaState();
}

class _TelaSelecaoEscalaState extends State<TelaSelecaoEscala> {
  Estilo estilo = Estilo();
  bool exibirConfirmacaoEscala = false;
  String nomeItemDrop = "";
  String tabelaSelecionada = "";
  late List<TabelaModelo> tabelas;

  var nomeTabelas;

  // referencia classe para gerenciar o banco de dados
  final bancoDados = BancoDeDados.instance;

  @override
  void initState() {
    super.initState();
    tabelas = [];
    consulta();
  }

  consulta() async {
    final tabelasRecuperadas = await bancoDados.consultaTabela();
    setState(() {
      for (var linha in tabelasRecuperadas) {
        nomeTabelas = linha['name'];
        nomeItemDrop = nomeTabelas;
        tabelas.add(TabelaModelo(nomeTabela: nomeTabelas));
        tabelas.removeWhere((element) =>
            element.nomeTabela
                .toString()
                .contains(Constantes.bancoTabelaLocalTrabalho) ||
            element.nomeTabela
                .toString()
                .contains(Constantes.bancoTabelaPessoa));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;
    return Theme(
        data: estilo.estiloGeral,
        child: WillPopScope(
            onWillPop: () async {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaInicial);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(Textos.nomeTelaSelecaoEscala,
                    textAlign: TextAlign.center),
              ),
              body: SizedBox(
                width: larguraTela,
                height: alturaTela -
                    alturaBarraStatus -
                    alturaAppBar -
                    Constantes.alturaNavigationBar,
                child: Stack(
                  children: [
                    FundoTela(
                        altura: alturaTela -
                            alturaBarraStatus -
                            alturaAppBar -
                            Constantes.alturaNavigationBar),
                    Positioned(
                        child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: larguraTela,
                                  child: Text(
                                    Textos.descricaoTelaSelecaoEscala,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  Text(
                                    Textos.descricaoListaEscala,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  DropdownButton(
                                    value: nomeItemDrop,
                                    icon: const Icon(Icons.list_alt_outlined),
                                    items: tabelas
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item.nomeTabela,
                                              child: Text(item.nomeTabela
                                                  .replaceAll(
                                                      RegExp(r'_'), ' ')),
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        nomeItemDrop = value!;
                                        tabelaSelecionada = value;
                                        exibirConfirmacaoEscala = true;
                                        //statusTelaCarregamento = true;
                                        //chamarRecuperarIDObservacao();
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Visibility(
                                    visible: exibirConfirmacaoEscala,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Escala selecionada:",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          tabelaSelecionada.replaceAll(
                                              RegExp(r'_'), ' '),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ))
                  ],
                ),
              ),
              bottomNavigationBar:
                  const SizedBox(height: 60, child: BarraNavegacao()),
            )));
  }
}
