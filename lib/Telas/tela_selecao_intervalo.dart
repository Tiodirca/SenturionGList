import 'package:flutter/material.dart';

import '../Uteis/Constantes.dart';
import '../Uteis/Textos.dart';
import '../Uteis/estilo.dart';
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
  Estilo estilo = Estilo();
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
  }

  // metodo para pegar as datas que irao conter o
  // intervalo de dias que serao trabalhados na escala
  pegarDatasIntervalo() {
    DateTime datasDiferenca = dataInicial;
    dynamic diferencaDias = datasDiferenca.difference(dataFinal).inDays;
    //verificando se a variavel recebeu um valor negativo
    if (diferencaDias.toString().contains("-")) {
      // passando para positivo
      diferencaDias = -(diferencaDias);
    }
    print(diferencaDias);
    //pegando todas as datas
    for (int interacao = 0; interacao <= diferencaDias; interacao++) {
      listaDatasAuxiliar.add(datasDiferenca);
      // definindo que a variavel vai receber ela mesma com a adicao de parametro de duracao
      datasDiferenca = datasDiferenca.add(const Duration(days: 1));
    }
    listarDatas();
    print(listaDatasAuxiliar.toString());
  }

  // metodo para listar as datas formatando elas para o formato que
  // contenha da data em numeros e o dia da semana
  listarDatas() {
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
  }

  // widget dos text fields
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
                dataFinal = novaData;
              }
              listaDatasAuxiliar = [];
              listaDatasFinal = [];
              pegarDatasIntervalo();
            });
          },
          readOnly: true,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: '${data.day}/${data.month}/${data.year}',
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
          child: Scaffold(
            appBar: AppBar(
              title: Text(Textos.nomeTelaSelecaoIntervalo,
                  textAlign: TextAlign.center),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                width: larguraTela,
                height: alturaTela -
                    alturaBarraStatus -
                    alturaAppBar -
                    alturaNavigationBar,
                child: Stack(
                  children: [
                    // o ultimo parametro e o tamanho do
                    // container do BUTTON NAVIGATION BAR
                    FundoTela(
                        altura: alturaTela -
                            alturaBarraStatus -
                            alturaAppBar -
                            alturaNavigationBar),
                    Positioned(
                        child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, right: 10.0, left: 10.0),
                              width: larguraTela,
                              child: Wrap(
                                alignment: WrapAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    width: larguraTela,
                                    child: Text(
                                      Textos.descricaoTelaSelecaoIntervalo,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
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
                              padding: const EdgeInsets.only(
                                  top: 10.0, right: 10.0, left: 10.0),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Text(
                                      Textos.descricaoListaSelecaoIntervalo,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      height: alturaTela * 0.35,
                                      width: larguraTela,
                                      child: ListView(
                                        children: [
                                          ...listaDatasFinal
                                              .map((e) => Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                            Icons.date_range),
                                                        const SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        SizedBox(
                                                          width: 250,
                                                          child: Text(
                                                            e,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        )
                                                      ],
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
                      SizedBox(
                          width: larguraTela * 0.4,
                          height: 45,
                          child: SingleChildScrollView(
                            child: Text(
                              "Dias da Semana :${widget.listaDias.toString().replaceAll("[", "").replaceAll("]", "")}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                          )),
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: FloatingActionButton(
                          heroTag: "btnAvancarSelecaoIntervalo",
                          backgroundColor: PaletaCores.corVerdeCiano,
                          onPressed: () {
                            var dados = {};
                            dados[Constantes.parametroGenero] = widget.genero;
                            dados[Constantes.parametroListaPessoas] =
                                widget.listaPessoas;
                            dados[Constantes.parametroListaLocal] =
                                widget.listaLocal;
                            dados[Constantes.parametroListaPeriodo] =
                                listaDatasFinal;
                            Navigator.pushReplacementNamed(
                                context, Constantes.rotaTelaListagem,
                                arguments: dados);
                          },
                          child: const Icon(Icons.arrow_forward, size: 40),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        height: 45,
                        width: larguraTela * 0.4,
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
          ),
          onWillPop: () async {
            var dados = {};
            dados[Constantes.parametroGenero] = widget.genero;
            dados[Constantes.parametroListaPessoas] = widget.listaPessoas;
            dados[Constantes.parametroListaLocal] = widget.listaLocal;
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaSelecaoDias,
                arguments: dados);

            return false;
          },
        ));
  }
}
