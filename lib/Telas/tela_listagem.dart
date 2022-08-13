import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/Servicos/banco_de_dados.dart';

import '../Uteis/Servicos/consulta.dart';
import '../Uteis/constantes.dart';
import '../Uteis/estilo.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/textos.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaListagem extends StatefulWidget {
  const TelaListagem({Key? key, required this.nomeTabela}) : super(key: key);

  final String nomeTabela;

  @override
  State<TelaListagem> createState() => _TelaListagemState();
}

class _TelaListagemState extends State<TelaListagem> {
  Estilo estilo = Estilo();
  List<Map<dynamic, dynamic>> itens = [];
  bool itemSelecionado = false;
  int idItem = 0;

  // referencia classe para gerenciar o banco de dados
  final bancoDados = BancoDeDados.instance;

  @override
  void initState() {
    super.initState();
    consultarDados();
  }

  // metodo responsavel por chamar metodo para fazer consulta ao banco de dados
  consultarDados() async {
    await Consulta.consultarTabelaSelecionada(widget.nomeTabela).then((value) {
      setState(() {
        itens = value;
      });
    });
  }

  Future<void> exibirConfirmacaoOpcoes(int id, String data) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Textos.legAlertOpcoes),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        "ID: ${id.toString()}",
                      ),
                      Text(
                        "Data: $data",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    bancoDados.excluir(id, widget.nomeTabela);
                    consultarDados();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(Textos.sucessoExluirItemBanco)));
                    Navigator.pop(context, false);
                  },
                  child: const Text("Excluir")),
              TextButton(
                  onPressed: () {
                    //bancoDados.excluir(id, Constantes.bancoTabelaPessoa);
                    // consultarPessoas();
                    //ScaffoldMessenger.of(context).showSnackBar(
                    //    SnackBar(content: Text(Textos.sucessoExluirItemBanco)));
                    //Navigator.pop(context, false);
                  },
                  child: const Text("Editar")),
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
          child: Scaffold(
            appBar: AppBar(
              title: Text(Textos.nomeTelaListagem, textAlign: TextAlign.center),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                width: larguraTela,
                height: alturaTela -
                    alturaBarraStatus -
                    alturaAppBar -
                    Constantes.alturaNavigationBar,
                child: Stack(
                  children: [
                    // o ultimo parametro e o tamanho do container do BUTTON NAVIGATION BAR
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
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, right: 10.0, left: 10.0),
                              width: larguraTela,
                              child: Column(
                                children: [
                                  Text(
                                    Textos.decricaoTelaListagem,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, right: 10.0, left: 10.0),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Text(
                                      Textos.legListaGerada,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 0.0),
                                    height: alturaTela * 0.3,
                                    width: larguraTela,
                                    child: ListView(
                                      children: [
                                        Center(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                              columnSpacing: 10,
                                              dividerThickness: 2.0,
                                              showCheckboxColumn: false,
                                              columns: [
                                                ...itens.first.keys
                                                    .map(
                                                      (e) => DataColumn(
                                                        label: Text(
                                                            e
                                                                .toString()
                                                                .replaceAll(
                                                                    "_", " "),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                            )),
                                                      ),
                                                    )
                                                    .toList()
                                              ],
                                              rows: itens
                                                  .map(
                                                    (item) => DataRow(
                                                        onSelectChanged:
                                                            (newValue) {
                                                          setState(() {
                                                            idItem = item
                                                                .values.first;
                                                          });
                                                          exibirConfirmacaoOpcoes(
                                                              idItem,
                                                              item.values
                                                                  .elementAt(
                                                                      1));
                                                        },
                                                        cells: [
                                                          ...item.values.map(
                                                            (e) {
                                                              return DataCell(SizedBox(
                                                                  width: 100,
                                                                  child: Text(e
                                                                      .toString())));
                                                            },
                                                          )
                                                        ]),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    )),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SizedBox(
              height: Constantes.alturaNavigationBar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: FloatingActionButton(
                      backgroundColor: PaletaCores.corVerdeCiano,
                      onPressed: () {},
                      child: Text(Textos.btnGerarPDF,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(height: 60, child: BarraNavegacao()),
                ],
              ),
            ),
          ),
          onWillPop: () async {
            Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
            return false;
          },
        ));
  }
}
