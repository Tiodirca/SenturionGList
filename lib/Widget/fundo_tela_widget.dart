import 'package:flutter/material.dart';

import '../Uteis/paleta_cores.dart';

class FundoTela extends StatelessWidget {
  const FundoTela({Key? key, required this.altura}) : super(key: key);

  final double altura;

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Container(
        height: altura,
        width: larguraTela,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: altura * 0.3,
              color: Colors.white,
              child: SizedBox(
                width: larguraTela,
                child: Container(
                  padding: const EdgeInsets.only(top: 40.0),
                  decoration: const BoxDecoration(
                      color: PaletaCores.corAdtl,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100.0),
                      )),
                ),
              ),
            ),
            Container(
              height: altura * 0.7,
              color: PaletaCores.corAdtl,
              width: larguraTela,
              child: Container(
                padding: const EdgeInsets.only(top: 40.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(100.0),
                    )),
              ),
            ),
          ],
        ));
  }
}
