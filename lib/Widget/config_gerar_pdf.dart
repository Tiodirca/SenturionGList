import 'package:flutter/material.dart';

import '../Uteis/GerarPDF.dart';
import '../Uteis/constantes.dart';
import '../Uteis/estilo.dart';
import '../Uteis/textos.dart';

class ConfigGerarPDF extends StatefulWidget {
  const ConfigGerarPDF(
      {Key? key, required this.itensBanco, required this.nomePDFPadrao})
      : super(key: key);
  final List<Map<dynamic, dynamic>> itensBanco;
  final String nomePDFPadrao;

  @override
  State<ConfigGerarPDF> createState() => _ConfigGerarPDFState();
}

class _ConfigGerarPDFState extends State<ConfigGerarPDF> {
  Estilo estilo = Estilo();
  TextEditingController nomePDF = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    nomePDF.text = widget.nomePDFPadrao;
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return SizedBox(
        height: alturaTela * 0.3,
        width: larguraTela * 0.7,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  Textos.decricaoNomePDF,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(
                      left: 5.0, top: 10.0, right: 5.0, bottom: 20.0),
                  width: larguraTela * 0.6,
                  child: TextField(
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    keyboardType: TextInputType.text,
                    controller: nomePDF,
                    decoration: InputDecoration(
                        labelText: Textos.labelNomePDF,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                  )),
              Theme(
                data: estilo.botoesBarraNavegacao,
                child: SizedBox(
                  width: Constantes.larguraBotoesBarraNavegacao,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      GerarPDF pdf = GerarPDF();
                      pdf.pegarDados(widget.itensBanco, nomePDF.text);
                    },
                    child: Text(Textos.btnCriar,
                        style: const TextStyle(
                            fontSize: Constantes.tamanhoLetraDescritivas,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
