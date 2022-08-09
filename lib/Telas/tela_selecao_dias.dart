import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/Constantes.dart';
import 'package:senturionglist/Uteis/Textos.dart';
import 'package:senturionglist/Widget/check_box_widget.dart';

import '../Modelo/check_box_modelo.dart';
import '../Uteis/estilo.dart';
import '../Uteis/paleta_cores.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaSelecaoDias extends StatefulWidget {
  const TelaSelecaoDias(
      {Key? key,
      required this.genero,
      required this.listaLocal,
      required this.listaPessoas})
      : super(key: key);

  final bool genero;
  final List<String> listaPessoas;
  final List<String> listaLocal;

  @override
  State<TelaSelecaoDias> createState() => _TelaSelecaoDiasState();
}

class _TelaSelecaoDiasState extends State<TelaSelecaoDias> {
  Estilo estilo = Estilo();
  String tipoEscala = "";
  List<String> listaDias = [];
  double alturaNavigationBar = 120.0;
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
    return Theme(data: estilo.estiloGeral, child: WillPopScope(
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
            title:
            Text(Textos.nomeTelaSelecaoDias, textAlign: TextAlign.center),
          ),
          body: SizedBox(
            width: larguraTela,
            height: alturaTela - alturaBarraStatus - alturaAppBar - alturaNavigationBar,
            child: Stack(
              children: [
                FundoTela(
                    altura:
                    alturaTela - alturaBarraStatus - alturaAppBar - alturaNavigationBar),
                Positioned(
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10.0,right: 10.0),
                                  child: Text(
                                    Textos.descricaoTelaSelecaoDias,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  Text(
                                    Textos.legLista,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
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
            height: alturaNavigationBar,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: larguraTela * 0.3,
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: FloatingActionButton(
                        heroTag: "btnAvancarSelecaoDias",
                        backgroundColor: PaletaCores.corVerdeCiano,
                        onPressed: () {
                          pegarItens();
                          if (listaDias.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(Textos.erroSemSelecaoCheck)));
                          } else {
                            var dados = {};
                            dados[Constantes.parametroGenero] = widget.genero;
                            dados[Constantes.parametroListaPessoas] =
                                widget.listaPessoas;
                            dados[Constantes.parametroListaLocal] =
                                widget.listaLocal;
                            dados[Constantes.parametroListaDias] = listaDias;
                            Navigator.pushReplacementNamed(
                                context, Constantes.rotaTelaSelecaoIntervalo,
                                arguments: dados);
                          }
                        },
                        child: const Icon(Icons.arrow_forward, size: 40),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10.0),
                      width: larguraTela * 0.3,
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
        )));
  }
}
