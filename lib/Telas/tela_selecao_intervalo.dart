import 'package:flutter/material.dart';

import '../Uteis/Constantes.dart';
import '../Uteis/Textos.dart';
import '../Uteis/paleta_cores.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';
import 'package:intl/intl.dart';

class TelaSelecaoIntervalo extends StatefulWidget {
  const TelaSelecaoIntervalo(
      {Key? key,
      required this.genero,
      required this.listaLocal,
      required this.listaPessoas,
      required this.listaDias})
      : super(key: key);
  final bool genero;
  final List<String> listaPessoas;
  final List<String> listaLocal;
  final List<String> listaDias;

  @override
  State<TelaSelecaoIntervalo> createState() => _TelaSelecaoIntervaloState();
}

class _TelaSelecaoIntervaloState extends State<TelaSelecaoIntervalo> {
  String tipoEscala = "";
  DateTime dataInicial = DateTime.now();
  DateTime dataFinal = DateTime.now();
  List<String> listaDatasFinal = [];
  List<DateTime> listaDatasAuxiliar = [];
  double alturaNavigationBar = 120.0;

  @override
  void initState() {
    super.initState();
    if (widget.genero) {
      tipoEscala = Textos.btnCooperadoras;
    } else {
      tipoEscala = Textos.btnCooperador;
    }
    print(widget.listaDias);
  }

  pegarDatasIntervalo() {
    DateTime datasDiferenca = dataInicial;
    dynamic diferencaDias = dataInicial.difference(dataFinal).inDays;
    //verificando se a variavel recebeu um valor negativo
    if (diferencaDias.toString().contains("-")) {
      // passando para positivo
      diferencaDias = -(diferencaDias);
    }
    //pegando todas as datas
    for (int interacao = 0; interacao <= diferencaDias; interacao++) {
      listaDatasAuxiliar.add(datasDiferenca);
      // definindo que a variavel vai receber ela mesma com a adicao de parametro de duracao
      datasDiferenca = datasDiferenca.add(const Duration(days: 1));
    }
    converterData();
  }

  converterData() {
    String diaEscala = "";
    // pegando todos os itens da lista
    for (int interacao = 0;
        interacao < listaDatasAuxiliar.length;
        interacao++) {
      String data = DateFormat("dd/MM/yyyy EEEE", "pt_BR")
          .format(listaDatasAuxiliar[interacao]);

      // pegando a lista de dias selecionados na tela de selecao dias
      for (int i = 0; i < widget.listaDias.length; i++) {
        diaEscala = widget.listaDias[i];
        // verificando se a variavel contem o valor contido no index da lista
        if (data.contains(diaEscala)) {
          listaDatasFinal.add(data); //adicionando variavel a uma lista
        }
      }
    }
    print(listaDatasFinal);
  }

  Widget textFieldDatas(double largura, String label, DateTime data) =>
      Container(
        padding:
            const EdgeInsets.only(left: 5.0, top: 0.0, right: 5.0, bottom: 5.0),
        width: largura * 0.3,
        child: TextFormField(
          onTap: () async {
            DateTime? novaData = await showDatePicker(
                builder: (context, child) {
                  return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: PaletaCores.corAdtl,
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                        dialogBackgroundColor: Colors.white,
                      ),
                      child: child!);
                },
                context: context,
                initialDate: data,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100));

            if (novaData == null) return;
            setState(() {
              if (label.contains(Textos.labelDataInicial)) {
                dataInicial = novaData;
              } else {
                listaDatasAuxiliar = [];
                listaDatasFinal = [];
                dataFinal = novaData;
                pegarDatasIntervalo();
              }
            });
          },
          readOnly: true,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.white),
              hintText: '${data.day}/${data.month}/${data.year}',
              fillColor: Colors.white,
              labelStyle: const TextStyle(
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              ),
              //definindo estilo do textfied ao ser clicado
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Textos.nomeTelaSelecaoIntervalo,
              textAlign: TextAlign.center),
          backgroundColor: PaletaCores.corAdtl,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: larguraTela,
            height: alturaTela - alturaBarraStatus - alturaAppBar - alturaNavigationBar,
            child: Stack(
              children: [
                // o ultimo parametro e o tamanho do container do BUTTON NAVIGATION BAR
                FundoTela(
                    altura:
                        alturaTela - alturaBarraStatus - alturaAppBar - alturaNavigationBar),
                Positioned(
                    child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 20.0, right: 10.0, left: 10.0),
                          width: larguraTela,
                          child: Wrap(
                            alignment: WrapAlignment.spaceAround,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                width: larguraTela,
                                child: Text(
                                  Textos.descricaoTelaSelecaoIntervalo,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    Textos.labelDataInicial,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  textFieldDatas(larguraTela,
                                      Textos.labelDataInicial, dataInicial),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    Textos.labelDataFinal,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  textFieldDatas(larguraTela,
                                      Textos.labelDataFinal, dataFinal),
                                ],
                              )
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                Textos.descricaoListaSelecaoIntervalo,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 10.0),
                                  height: alturaTela * 0.4,
                                  width: larguraTela,
                                  child: ListView(
                                    children: [
                                      ...listaDatasFinal
                                          .map((e) => Text(
                                                e,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ))
                                          .toList()
                                    ],
                                  ))
                            ],
                          ),
                        ))
                  ],
                )),
              ],
            ),
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
                      backgroundColor: PaletaCores.corVerdeCiano,
                      onPressed: () {},
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
        backgroundColor: Colors.white,
      ),
      onWillPop: () async {
        var dados = {};
        dados[Constantes.parametroGenero] = widget.genero;
        dados[Constantes.parametroListaPessoas] = widget.listaPessoas;
        dados[Constantes.parametroListaLocal] = widget.listaLocal;
        Navigator.pushReplacementNamed(context, Constantes.rotaTelaSelecaoDias,
            arguments: dados);

        return false;
      },
    );
  }
}
