import 'package:flutter/material.dart';

import '../../Modelo/check_box_modelo.dart';
import '../../Uteis/constantes.dart';
import '../../Uteis/estilo.dart';
import '../../Uteis/paleta_cores.dart';
import '../../Uteis/textos.dart';
import '../../Widget/barra_navegacao.dart';
import '../../Widget/check_box_widget.dart';
import '../../Widget/fundo_tela_widget.dart';

class TelaSelecaoDiasSemana extends StatefulWidget {
  const TelaSelecaoDiasSemana(
      {Key? key,
      required this.genero,
      required this.listaLocal,
      required this.listaPessoas})
      : super(key: key);

  final bool genero;
  final List<String> listaPessoas;
  final List<String> listaLocal;

  @override
  State<TelaSelecaoDiasSemana> createState() => _TelaSelecaoDiasSemanaState();
}

class _TelaSelecaoDiasSemanaState extends State<TelaSelecaoDiasSemana> {
  Estilo estilo = Estilo();
  String tipoEscala = "";
  List<String> listaDias = [];
  final List<CheckBoxModel> itens = [
    CheckBoxModel(texto: Textos.diaSegunda),
    CheckBoxModel(texto: Textos.diaTerca),
    CheckBoxModel(texto: Textos.diaQuarta),
    CheckBoxModel(texto: Textos.diaQuinta),
    CheckBoxModel(texto: Textos.diaSexta),
    CheckBoxModel(texto: Textos.diaSabado),
    CheckBoxModel(texto: Textos.diaDomingo),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.genero) {
      tipoEscala = Textos.btnCooperadoras;
    } else {
      tipoEscala = Textos.btnCooperador;
    }
  }

  // metodo para pegar os itens que foram selecionados no check box
  pegarItens() {
    for (var element in itens) {
      if (element.checked == true) {
        listaDias.add(element.texto);
      }
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
            onWillPop: () async {
              var dados = {};
              dados[Constantes.parametroGenero] = widget.genero;
              dados[Constantes.parametroListaPessoas] = widget.listaPessoas;
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaCadastroLocalTrabalho,
                  arguments: dados);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(Textos.nomeTelaSelecaoDias,
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
                                      top: 10.0, left: 10.0, right: 10.0),
                                  child: Text(
                                    Textos.descricaoTelaSelecaoDias,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        fontSize:
                                            Constantes.tamanhoLetraDescritivas,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 10.0),
                              child: Column(
                                children: [
                                  Text(
                                    Textos.legLista,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize:
                                            Constantes.tamanhoLetraDescritivas,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                      height: alturaTela * 0.4,
                                      width: larguraTela,
                                      child: ListView(
                                        children: [
                                          ...itens
                                              .map((e) => CheckboxWidget(
                                                    item: e,
                                                  ))
                                              .toList()
                                        ],
                                      ))
                                ],
                              ),
                            )),
                      ],
                    ))
                  ],
                ),
              ),
              bottomNavigationBar: SizedBox(
                height: Constantes.alturaNavigationBar,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: larguraTela * 0.3,
                        ),
                        Theme(
                          data: estilo.botoesBarraNavegacao,
                          child: SizedBox(
                            width: Constantes.larguraBotoesBarraNavegacao,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                pegarItens();
                                if (listaDias.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              Textos.erroSemSelecaoCheck)));
                                } else {
                                  var dados = {};
                                  dados[Constantes.parametroGenero] =
                                      widget.genero;
                                  dados[Constantes.parametroListaPessoas] =
                                      widget.listaPessoas;
                                  dados[Constantes.parametroListaLocal] =
                                      widget.listaLocal;
                                  dados[Constantes.parametroListaDias] =
                                      listaDias;
                                  Navigator.pushReplacementNamed(context,
                                      Constantes.rotaTelaSelecaoPeriodo,
                                      arguments: dados);
                                }
                              },
                              child: const Icon(Icons.arrow_forward, size: 40),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10.0),
                          width: larguraTela * 0.3,
                          child: Text(Textos.txtTipoEscala + tipoEscala,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(height: 60, child: BarraNavegacao()),
                  ],
                ),
              ),
            )));
  }
}
