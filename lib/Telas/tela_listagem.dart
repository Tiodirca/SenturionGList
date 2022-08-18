import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/Servicos/banco_de_dados.dart';

import '../Uteis/Servicos/consultas.dart';
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
  int idItem = 0;
  String dataItem = "";
  List<String> chaves = [];

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
    for (var value1 in itens.first.keys) {
      chaves.add(value1.toString().replaceAll("_", " "));
    }
  }

  Future<void> exibirConfirmacaoExclusao(int id, String data) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Textos.legAlertExclusao),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        "ID: ${id.toString()}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Data: $data",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
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
                    Navigator.pushReplacementNamed(
                        context, Constantes.rotaTelaListagem,
                        arguments: widget.nomeTabela);
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
                                  top: 10.0, right: 15.0, left: 15.0),
                              width: larguraTela,
                              child: Column(
                                children: [
                                  Text(
                                    Textos.decricaoTelaListagem,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        fontSize:
                                            Constantes.tamanhoLetraDescritivas,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, right: 10.0, left: 10.0),
                              width: larguraTela,
                              height: alturaTela * 0.5,
                              child: Container(
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
                                          dividerThickness: 1.0,
                                          showCheckboxColumn: false,
                                          columns: [
                                            ...chaves.map(
                                              (e) {
                                                return DataColumn(
                                                  label: Text(
                                                      e
                                                          .toString()
                                                          .replaceAll("_", " "),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: Constantes
                                                              .tamanhoLetraDescritivas,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                );
                                              },
                                            ),
                                            const DataColumn(
                                              label: Text("Editar",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: Constantes
                                                          .tamanhoLetraDescritivas,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            const DataColumn(
                                              label: Text("Excluir",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: Constantes
                                                          .tamanhoLetraDescritivas,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ],
                                          rows: itens
                                              .map(
                                                (item) => DataRow(cells: [
                                                  ...item.values.map(
                                                    (e) {
                                                      return DataCell(SizedBox(
                                                          width: 120,
                                                          child: Center(
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                e.toString(),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            18),
                                                              ),
                                                            ),
                                                          )));
                                                    },
                                                  ),
                                                  DataCell(SizedBox(
                                                    width: 50,
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child:
                                                          FloatingActionButton(
                                                        heroTag:
                                                            "btnEditarItem${item.values.first}",
                                                        backgroundColor:
                                                            PaletaCores
                                                                .corAmarela,
                                                        onPressed: () {
                                                          idItem =
                                                              item.values.first;
                                                          var dados = {};
                                                          dados[Constantes
                                                                  .parametroEdicaoNomeTabela] =
                                                              widget.nomeTabela;
                                                          dados[Constantes
                                                                  .parametroEdicaoIdItem] =
                                                              idItem;
                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  context,
                                                                  Constantes
                                                                      .rotaTelaEdicao,
                                                                  arguments:
                                                                      dados);
                                                        },
                                                        child: const Icon(
                                                            Icons.edit,
                                                            size: 20),
                                                      ),
                                                    ),
                                                  )),
                                                  DataCell(SizedBox(
                                                    width: 50,
                                                    child: SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child:
                                                          FloatingActionButton(
                                                        heroTag:
                                                            "btnExcluirItem${item.values.first}",
                                                        backgroundColor:
                                                            Colors.red,
                                                        onPressed: () {
                                                          setState(() {
                                                            dataItem = item
                                                                .values
                                                                .elementAt(1);
                                                            idItem = item
                                                                .values.first;
                                                          });
                                                          exibirConfirmacaoExclusao(
                                                              idItem, dataItem);
                                                        },
                                                        child: const Icon(
                                                            Icons
                                                                .delete_forever,
                                                            size: 20),
                                                      ),
                                                    ),
                                                  ))
                                                ]),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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
                    width: Constantes.tamanhoFloatButtonNavigationBar,
                    height: Constantes.tamanhoFloatButtonNavigationBar,
                    child: FloatingActionButton(
                      heroTag: "btnListagemGerarPDF",
                      backgroundColor: PaletaCores.corVerdeCiano,
                      onPressed: () {},
                      child: Text(Textos.btnGerarPDF,
                          style: const TextStyle(
                              fontSize: Constantes.tamanhoLetraDescritivas,
                              fontWeight: FontWeight.bold)),
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
