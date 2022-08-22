import 'package:flutter/material.dart';

import '../Uteis/GerarPDF.dart';
import '../Uteis/constantes.dart';
import '../Uteis/estilo.dart';
import '../Uteis/paleta_cores.dart';
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
  TextEditingController observacaoText = TextEditingController(text: "");
  int valorRadioButton = 0;
  bool observacao = false;

  @override
  void initState() {
    super.initState();
    nomePDF.text = widget.nomePDFPadrao;
  }

  Widget textFields(
          double larguraTela, String label, TextEditingController controller) =>
      Container(
          padding: const EdgeInsets.only(
              left: 5.0, top: 10.0, right: 5.0, bottom: 20.0),
          width: larguraTela * 0.6,
          child: TextField(
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.text,
            controller: controller,
            decoration: InputDecoration(
                labelText: label,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                )),
          ));

  //metodo para mudar o estado do radio button
  void mudarRadioButton(int value) {
    setState(() {
      valorRadioButton = value;
      switch (valorRadioButton) {
        case 0:
          setState(() {
            observacao = false;
          });
          break;
        case 1:
          setState(() {
            observacao = true;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return SizedBox(
        height: alturaTela * 0.4,
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
              textFields(larguraTela, Textos.labelNomePDF, nomePDF),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  Textos.descricaoObservacaoPDF,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                      value: 0,
                      activeColor: PaletaCores.corAzul,
                      groupValue: valorRadioButton,
                      onChanged: (_) {
                        mudarRadioButton(0);
                      }),
                  const Text(
                    'Não',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  Radio(
                      value: 1,
                      activeColor: PaletaCores.corAdtl,
                      groupValue: valorRadioButton,
                      onChanged: (_) {
                        mudarRadioButton(1);
                      }),
                  const Text(
                    'Sim',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Visibility(
                visible: observacao,
                child: textFields(
                    larguraTela, Textos.labelObservacaoPDF, observacaoText),
              ),
              Theme(
                data: estilo.botoesBarraNavegacao,
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: Constantes.larguraBotoesBarraNavegacao,
                  height: Constantes.alturaBotoesNavegacao,
                  child: ElevatedButton(
                    onPressed: () {
                      GerarPDF pdf = GerarPDF();
                      pdf.pegarDados(
                          widget.itensBanco, nomePDF.text, observacaoText.text);
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
