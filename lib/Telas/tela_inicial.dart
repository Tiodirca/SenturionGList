import 'package:flutter/material.dart';

import '../Uteis/constantes.dart';
import '../Uteis/estilo.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/textos.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaInicial extends StatelessWidget {
  TelaInicial({Key? key}) : super(key: key);

  Estilo estilo = Estilo();

  Widget botoes(BuildContext context, String tituloBotao) => SizedBox(
        height: 50,
        width: 160,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
          ),
          onPressed: () {
            if (tituloBotao == Textos.btnCooperador) {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaCadastroPessoas,
                  arguments: false);
            } else {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaCadastroPessoas,
                  arguments: true);
            }
          },
          child: Text(
            tituloBotao,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;
    return Theme(
      data: estilo.estiloGeral,
      child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: Container(
                height: alturaTela - alturaBarraStatus - alturaAppBar,
                width: larguraTela,
                color: PaletaCores.corAzul,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      FundoTela(
                          altura:
                              alturaTela - alturaBarraStatus - alturaAppBar),
                      Positioned(
                          child: SizedBox(
                              width: larguraTela,
                              height:
                                  alturaTela - alturaBarraStatus - alturaAppBar,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20.0, left: 20.0),
                                    child: Text(
                                      Textos.legSelecaoTipoEscala,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: alturaTela * 0.5,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          botoes(context, Textos.btnCooperador),
                                          botoes(
                                              context, Textos.btnCooperadoras)
                                        ],
                                      ),
                                    ),
                                  )
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
