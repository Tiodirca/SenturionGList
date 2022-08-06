import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/Constantes.dart';
import 'package:senturionglist/Uteis/Textos.dart';
import 'package:senturionglist/Widget/check_box_widget.dart';

import '../Modelo/check_box_modelo.dart';
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

final List<CheckBoxModel> itens = [
  CheckBoxModel(texto: Textos.diaSegunda),
  CheckBoxModel(texto: Textos.diaTerca),
  CheckBoxModel(texto: Textos.diaQuarta),
  CheckBoxModel(texto: Textos.diaQuinta),
  CheckBoxModel(texto: Textos.diaSexta),
  CheckBoxModel(texto: Textos.diaSabado),
  CheckBoxModel(texto: Textos.diaDomingo),
];

class _TelaSelecaoDiasState extends State<TelaSelecaoDias> {
  String tipoEscala = "";

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
    return WillPopScope(
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
            actionsIconTheme: const IconThemeData(
              size: 30,
            ),
            title:
                Text(Textos.nomeTelaSelecaoDias, textAlign: TextAlign.center),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                width: larguraTela * 0.3,
                child: Text(Textos.txtTipoEscala + tipoEscala,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 16)),
              ),
            ],
            backgroundColor: PaletaCores.corAzul,
            elevation: 0,
          ),
          body: Container(
              height: alturaTela,
              width: larguraTela,
              color: PaletaCores.corAzul,
              child: Stack(
                children: [
                  FundoTela(altura: alturaTela,),
                  Positioned(
                      child: Container(
                        width: larguraTela,
                        height: alturaTela,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                Textos.legSelecaoTipoEscala,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Center(
                                child: Container(
                                    padding:
                                    const EdgeInsets.only(top: 10.0),
                                    height: 400,
                                    width: larguraTela ,
                                    child: ListView(
                                      children: [
                                        ...itens
                                            .map((e) => CheckboxWidget(
                                          item: e,
                                        ))
                                            .toList()
                                      ],
                                    )),
                              )
                            ],
                          ),
                        )
                      )
                  ),
                ],
              )),
          bottomNavigationBar: SizedBox(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: FloatingActionButton(
                    backgroundColor: PaletaCores.corVerdeCiano,
                    onPressed: () {},
                    child: const Icon(Icons.arrow_forward, size: 30),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const BarraNavegacao()
              ],
            ),
          ),
          backgroundColor: Colors.white,
        ));
  }
}
