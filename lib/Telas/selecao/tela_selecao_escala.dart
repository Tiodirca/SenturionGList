import 'package:flutter/material.dart';

import '../../Uteis/Servicos/banco_de_dados.dart';
import '../../Uteis/constantes.dart';
import '../../Uteis/estilo.dart';
import '../../Uteis/paleta_cores.dart';
import '../../Uteis/textos.dart';
import '../../Widget/barra_navegacao.dart';
import '../../Widget/fundo_tela_widget.dart';

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
  bool exibirLista = false;
  String nomeItemDrop = "";
  String tabelaSelecionada = "";
  late List<String> tabelas;

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
        var nomeTabelas = linha['name'];
        nomeItemDrop = nomeTabelas.toString();
        tabelas.add(nomeTabelas.toString());
        tabelas.removeWhere((element) =>
            element.toString().contains(Constantes.bancoTabelaLocalTrabalho) ||
            element.toString().contains("android_metadata") ||
            element.toString().contains(Constantes.bancoTabelaPessoa));
      }
      if (tabelas.isNotEmpty) {
        exibirLista = true;
      } else {
        exibirLista = false;
      }
    });
  }

  //metodo para exibir alerta para excluir tarefa do banco de dados
  Future<void> exibirConfirmacaoExcluir() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Textos.legAlertExclusao),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    bancoDados.excluirTabela(tabelaSelecionada);
                    Navigator.pushReplacementNamed(
                        context, Constantes.rotaTelaSelecaoEscala);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(Textos.sucessoExluirItemBanco)));
                  },
                  child: const Text("Excluir")),
            ],
          );
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
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    width: larguraTela,
                                    child: Text(
                                      Textos.descricaoTelaSelecaoEscala,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: Constantes.tamanhoLetraDescritivas, color: Colors.white),
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
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        if (exibirLista) {
                                          return DropdownButton(
                                            value: nomeItemDrop,
                                            icon: const Icon(
                                                Icons.list_alt_outlined),
                                            items: tabelas
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                          item.replaceAll(
                                                              RegExp(r'_'),
                                                              ' '),style: const TextStyle(
                                                        fontSize: Constantes.tamanhoLetraDescritivas
                                                      )),
                                                    ))
                                                .toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                nomeItemDrop = value!;
                                                tabelaSelecionada = value;
                                                exibirConfirmacaoEscala = true;
                                              });
                                            },
                                          );
                                        } else {
                                          return Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Text(
                                              Textos.txtSemEscala,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          );
                                        }
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
                                          Text(
                                            Textos.txtEscalaSelecionada,
                                            style:
                                                const TextStyle(fontSize: Constantes.tamanhoLetraDescritivas),
                                          ),
                                          Text(
                                            tabelaSelecionada.replaceAll(
                                                RegExp(r'_'), ' '),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Constantes.tamanhoLetraDescritivas),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 10.0, left: 10.0),
                                            width: 40,
                                            height: 40,
                                            child: FloatingActionButton(
                                                backgroundColor: Colors.red,
                                                onPressed: () {
                                                  exibirConfirmacaoExcluir();
                                                },
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 30,
                                                )),
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
                bottomNavigationBar: SizedBox(
                  height: exibirConfirmacaoEscala
                      ? Constantes.alturaNavigationBar
                      : 70.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: exibirConfirmacaoEscala,
                        child: SizedBox(
                          width: Constantes.tamanhoFloatButtonNavigationBar,
                          height: Constantes.tamanhoFloatButtonNavigationBar,
                          child: FloatingActionButton(
                            heroTag: "btnAvancarSelecaoEscala",
                            backgroundColor: PaletaCores.corVerdeCiano,
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, Constantes.rotaTelaListagem,
                                  arguments: tabelaSelecionada);
                            },
                            child: Text(Textos.btnUsarEscala,
                                style: const TextStyle(
                                    fontSize: Constantes.tamanhoLetraDescritivas, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(height: 60, child: BarraNavegacao()),
                    ],
                  ),
                ))));
  }
}