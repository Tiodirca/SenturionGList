import 'dart:math';

import 'package:flutter/material.dart';

import '../Uteis/Textos.dart';
import '../Uteis/estilo.dart';
import '../Uteis/paleta_cores.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaListagem extends StatefulWidget {
  const TelaListagem(
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
  State<TelaListagem> createState() => _TelaListagemState();
}

class _TelaListagemState extends State<TelaListagem> {
  Estilo estilo = Estilo();
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
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
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
