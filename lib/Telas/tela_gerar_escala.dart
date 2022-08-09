import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/Servicos/banco_de_dados.dart';

import '../Uteis/Textos.dart';
import '../Uteis/estilo.dart';
import '../Uteis/paleta_cores.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaGerarEscala extends StatefulWidget {
  const TelaGerarEscala(
      {Key? key,
      required this.genero,
      required this.listaLocal,
      required this.listaPessoas,
      required this.listaPeriodo})
      : super(key: key);

  final bool genero;
  final List<String> listaPessoas;
  final List<String> listaLocal;
  final List<String> listaPeriodo;

  @override
  State<TelaGerarEscala> createState() => _TelaGerarEscalaState();
}

class _TelaGerarEscalaState extends State<TelaGerarEscala> {
  Estilo estilo = Estilo();

  // referencia classe para gerenciar o banco de dados
  final bancoDados = BancoDeDados.instance;
  String tipoEscala = "";
  double alturaNavigationBar = 120.0;

  @override
  void initState() {
    super.initState();
    if (widget.genero) {
      tipoEscala = Textos.btnCooperadoras;
    } else {
      tipoEscala = Textos.btnCooperador;
    }
    String querySQL = "";
    String teste = "";
    // formando query para criar tabela com base na lista passada
    widget.listaLocal
        .map(
          (e) => querySQL = "$querySQL $e TEXT NOT NULL,",
        )
        .toList();

    int tamanho = querySQL.length;
    print(querySQL.substring(0, tamanho - 1));
    String tabela = "teste";
    //bancoDados.criarTabela(querySQL, tabela);

    // teste();
    // Timer(const Duration(seconds: 10), () {
    //   consulta();
    // });

    for (int i = 0; i < widget.listaPeriodo.length; i++) {
      Random random = Random();
      Map<String,dynamic> linha = {};
      widget.listaLocal
          .map(
            (e){
              int randomNumber = random.nextInt(widget.listaPessoas.length);
              linha[e] = widget.listaPessoas[randomNumber];
            },
      )
          .toList();
      print(linha);
    }
  }

  // teste() async {
  //   Map<String, dynamic> linha = {
  //     'altura': "_controllerNomePessoa.text",
  //     'largura': "valorGenero"
  //   };
  //   await bancoDados.inserir(linha, "teste");
  // }
  //
  // consulta() async {
  //   final registros = await bancoDados.consultarLinhas("teste");
  //   for (var linha in registros) {
  //     print(linha);
  //   }
  // }

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
                    alturaNavigationBar,
                child: Stack(
                  children: [
                    // o ultimo parametro e o tamanho do container do BUTTON NAVIGATION BAR
                    FundoTela(
                        altura: alturaTela -
                            alturaBarraStatus -
                            alturaAppBar -
                            alturaNavigationBar),
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
                                  Text(
                                    Textos.legListaGerada,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 0.0),
                                    height: alturaTela * 0.2,
                                    width: larguraTela,
                                    child: ListView(
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columnSpacing: 10,
                                            columns: [
                                              ...widget.listaLocal
                                                  .map(
                                                    (e) => DataColumn(
                                                      label: Text(e,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                          )),
                                                    ),
                                                  )
                                                  .toList()
                                            ],
                                            rows: widget.listaPeriodo
                                                .map(
                                                  (item) => DataRow(cells: [
                                                    ...widget.listaLocal.map(
                                                      (e) {
                                                        Random random =
                                                            Random();
                                                        int randomNumber =
                                                            random.nextInt(widget
                                                                .listaPessoas
                                                                .length);
                                                        return DataCell(SizedBox(
                                                            width: 190,
                                                            child: Text(
                                                                widget.listaPessoas[
                                                                    randomNumber],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center)));
                                                      },
                                                    )
                                                  ]),
                                                )
                                                .toList(),
                                          ),
                                        ),
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
              height: alturaNavigationBar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: larguraTela * 0.4,
                        height: 45,
                      ),
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: FloatingActionButton(
                          backgroundColor: PaletaCores.corVerdeCiano,
                          onPressed: () {},
                          child: const Icon(Icons.arrow_forward, size: 40),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        height: 45,
                        width: larguraTela * 0.4,
                        child: Text(Textos.txtTipoEscala + tipoEscala,
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const BarraNavegacao()
                ],
              ),
            ),
          ),
          onWillPop: () async {
            var dados = {};
            //dados[Constantes.parametroGenero] = widget.genero;
            //dados[Constantes.parametroListaPessoas] = widget.listaPessoas;
            //dados[Constantes.parametroListaLocal] = widget.listaLocal;
            //Navigator.pushReplacementNamed(
            //    context, Constantes.rotaTelaSelecaoDias,
            //    arguments: dados);
            return false;
          },
        ));
  }
}
