import 'package:flutter/material.dart';

import '../Uteis/constantes.dart';
import '../Uteis/paleta_cores.dart';

class BarraNavegacao extends StatelessWidget {
  const BarraNavegacao({Key? key}) : super(key: key);

  Widget botoesIcones(String tipoIcone, BuildContext context) =>
      SizedBox(
          height: 60,
          width: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: PaletaCores.corAdtl),
              primary: PaletaCores.corAdtl,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: () {
              if (tipoIcone == Constantes.tipoIconeHome) {
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaInicial);
              }else if( tipoIcone == Constantes.tipoIconeLista){
                Navigator.pushReplacementNamed(
                    context, Constantes.rotaTelaSelecaoEscala);
              }
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (tipoIcone == Constantes.tipoIconeHome) {
                  return const Icon(
                    Icons.home_outlined,
                    size: 30,
                  );
                } else if (tipoIcone == Constantes.tipoIconeLista) {
                  return const Icon(
                    Icons.list_alt_outlined,
                    size: 30,
                  );
                } else {
                  return const Icon(
                    Icons.settings,
                    size: 30,
                  );
                }
              },
            ),
          ));

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery
        .of(context)
        .size
        .width;
    return  Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      elevation: 10,
      color: PaletaCores.corAdtl,
      child: SizedBox(
        width: larguraTela,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            botoesIcones(Constantes.tipoIconeHome, context),
            botoesIcones(Constantes.tipoIconeLista, context),
            botoesIcones(Constantes.tipoIconeConfiguracao, context),
          ],
        ),
      ),
    );
  }
}
