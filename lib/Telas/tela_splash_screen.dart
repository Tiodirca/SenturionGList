import 'dart:async';

import 'package:flutter/material.dart';
import 'package:senturionglist/Widget/tela_carregamento.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Uteis/constantes.dart';
import '../Uteis/paleta_cores.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaSplashScreen extends StatefulWidget {
  const TelaSplashScreen({Key? key}) : super(key: key);

  @override
  State<TelaSplashScreen> createState() => _TelaSplashScreenState();
}

class _TelaSplashScreenState extends State<TelaSplashScreen> {
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaInicial);
    });
    gravarDadosPadrao();
  }

  gravarDadosPadrao() async {
    //metodo para gravar informacoes padroes no share preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final horaMudada = prefs.getString('horaMudada') ?? '';
    if (horaMudada != "sim") {
      prefs.setString(Constantes.primeiroHorarioSemana,
          Constantes.horarioPrimeiroSemanaPadrao);
      prefs.setString(Constantes.segundoHorarioSemana,
          Constantes.horarioSegundoSemanaPadrao);
      prefs.setString(Constantes.primeiroHorarioFinalSemana,
          Constantes.horarioPrimeiroFinalSemanaPadrao);
      prefs.setString(Constantes.segundoHorarioFinalSemana,
          Constantes.horarioSegundoFinalSemanaPadrao);
    }
  }


  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;
    return Scaffold(
      body: Container(
          height: alturaTela - alturaBarraStatus - alturaAppBar,
          width: larguraTela,
          color: PaletaCores.corAzul,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                FundoTela(
                    altura: alturaTela - alturaBarraStatus - alturaAppBar),
                Positioned(
                    child: SizedBox(
                        width: larguraTela,
                        height: alturaTela - alturaBarraStatus - alturaAppBar,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: larguraTela * 0.9,
                              height: alturaTela * 0.2,
                              child: Image.asset(
                                "assets/imagens/logo_app.png",
                              ),
                            ),
                            const TelaCarregamento()
                          ],
                        )))
              ],
            ),
          )),
    );
  }
}
