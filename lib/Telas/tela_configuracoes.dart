import 'package:flutter/material.dart';
import 'package:senturionglist/Widget/config_hora_troca_turno.dart';

import '../Uteis/constantes.dart';
import '../Uteis/estilo.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/textos.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({Key? key}) : super(key: key);

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  Estilo estilo = Estilo();
  bool boolAtivarConfigHoraTroca = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(Textos.nomeTelaConfiguracoes),
            ),
            body: Container(
                height: alturaTela - alturaBarraStatus - alturaAppBar,
                width: larguraTela,
                color: PaletaCores.corAzul,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      FundoTela(
                          altura: alturaTela -
                              alturaBarraStatus -
                              alturaAppBar -
                              60),
                      Positioned(
                          child: SizedBox(
                              width: larguraTela,
                              height: alturaTela * 0.8 -
                                  alturaBarraStatus -
                                  alturaAppBar -
                                  60,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20.0, left: 20.0),
                                    child: Text(
                                      Textos.descriacaoTelaConfiguracoes,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Constantes
                                              .tamanhoLetraDescritivas,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 160,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          boolAtivarConfigHoraTroca = true;
                                        });
                                      },
                                      child: Text(
                                        Textos.btnConfigHoraTroca,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ))),
                      Positioned(
                          child: SizedBox(
                              width: larguraTela,
                              height: alturaTela -
                                  alturaBarraStatus -
                                  alturaAppBar -
                                  60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                      visible: boolAtivarConfigHoraTroca,
                                      child: SizedBox(
                                        height: alturaTela * 0.7,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: FloatingActionButton(
                                                  backgroundColor: Colors.red,
                                                  child: const Icon(Icons.close,
                                                      size: 30),
                                                  onPressed: () {
                                                    setState(() {
                                                      boolAtivarConfigHoraTroca =
                                                          false;
                                                    });
                                                  },
                                                ),
                                              ),
                                              const ConfigHoraTrocaTurno()
                                            ],
                                          ),
                                        ),
                                      ))
                                ],
                              )))
                    ],
                  ),
                )),
            backgroundColor: Colors.white,
            bottomNavigationBar:
                const SizedBox(height: 60, child: BarraNavegacao()),
          )),
    );
  }
}
