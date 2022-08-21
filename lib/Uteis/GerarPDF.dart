import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:senturionglist/Uteis/salvarPDF/SavePDFMobile.dart';
import 'package:senturionglist/Uteis/textos.dart';

class GerarPDF {
  List<String> chaves = [];

  pegarDados(List<Map<dynamic, dynamic>> itens) {
    itens.forEach((element) {
      print(element["Uniforme"]);
    });
    for (var value1 in itens.first.keys) {
      chaves.add(value1.toString().replaceAll("_", " "));
    }

    Map<dynamic,dynamic> exibir = {};
    exibir[1] = true;
    exibir[2] = false;
    exibir[3] = true;
    gerarPDF("nomePDF", itens,exibir);
    chaves[0] = "";
  }

  gerarPDF(String nomePDF, List<Map<dynamic, dynamic>> itens,Map<dynamic, dynamic> exibir) async {
    final pdfLib.Document pdf = pdfLib.Document();
    //definindo que a variavel vai receber o caminho da imagem para serem exibidas
    final image = (await rootBundle.load('assets/imagens/logo_app.png'))
        .buffer
        .asUint8List();
    final imageLogo = (await rootBundle.load('assets/imagens/logo_app.png'))
        .buffer
        .asUint8List();

    //adicionando a pagina ao pdf
    pdf.addPage(pdfLib.MultiPage(
        //definindo formato
        margin:
            const pdfLib.EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 10),
        //CABECALHO DO PDF
        header: (context) => pdfLib.Column(
              children: [
                pdfLib.Container(
                  alignment: pdfLib.Alignment.centerRight,
                  child: pdfLib.Column(children: [
                    pdfLib.Image(pdfLib.MemoryImage(image),
                        width: 50, height: 50),
                    pdfLib.Text("Textos.nomeIgreja"),
                  ]),
                ),
                pdfLib.SizedBox(height: 5),
                pdfLib.Text("extos.txtCabecalhoPDF",
                    textAlign: pdfLib.TextAlign.center),
              ],
            ),
        //RODAPE DO PDF
        footer: (context) => pdfLib.Column(children: [
              pdfLib.Container(
                  child: pdfLib.Column(children: [
                pdfLib.Text("Observações:"),
                pdfLib.Container(
                  child: pdfLib.Text("observacao",
                      textAlign: pdfLib.TextAlign.center,
                      style:
                          pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold)),
                ),
              ])),
              pdfLib.SizedBox(height: 20.0),
              pdfLib.Container(
                child: pdfLib.Text(Textos.pdfRodape,
                    textAlign: pdfLib.TextAlign.center),
              ),
              pdfLib.Container(
                  padding: const pdfLib.EdgeInsets.only(
                      left: 0.0, top: 10.0, bottom: 0.0, right: 0.0),
                  alignment: pdfLib.Alignment.centerRight,
                  child: pdfLib.Container(
                    alignment: pdfLib.Alignment.centerRight,
                    child: pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                        children: [
                          pdfLib.Text(Textos.pdfEscalaGerada,
                              textAlign: pdfLib.TextAlign.center),
                          pdfLib.SizedBox(width: 10),
                          pdfLib.Image(pdfLib.MemoryImage(imageLogo),
                              width: 20, height: 20),
                        ]),
                  )),
            ]),
        pageFormat: PdfPageFormat.a4,
        orientation: pdfLib.PageOrientation.portrait,
        //CORPO DO PDF
        build: (context) => [
              pdfLib.SizedBox(height: 10),
              pdfLib.Table.fromTextArray(
                  cellPadding: const pdfLib.EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 5.0),
                  headerPadding: const pdfLib.EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 5.0),
                  cellAlignment: pdfLib.Alignment.center,
                  headerHeight: 1,
                  data: <List<String>>[
                    chaves,
                    ...itens.map(
                      (e2) {
                        return [
                          ...e2.values.map(
                            (e) {
                              int elemento = 0;
                              print(exibir.values.where((element) => element == true));
                              if (e == e2.values.elementAt(0)) {
                                return "";
                              }else {
                              return e.toString();
                              }
                            },
                          )
                        ];
                      },
                    )
                  ]),
            ]));

    List<int> bytes = await pdf.save();
    salvarPDF(bytes, '$nomePDF.pdf');
  }
}
