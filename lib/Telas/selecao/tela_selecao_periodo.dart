import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:senturionglist/Uteis/constantes.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/paleta_cores.dart';
import 'package:senturionglist/Uteis/textos.dart';
import 'package:senturionglist/Widget/barra_navegacao.dart';
import 'package:senturionglist/Widget/fundo_tela_widget.dart';

class TelaSelecaoPeriodo extends StatefulWidget {
  const TelaSelecaoPeriodo(
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
  State<TelaSelecaoPeriodo> createState() => _TelaSelecaoPeriodoState();
}

class _TelaSelecaoPeriodoState extends State<TelaSelecaoPeriodo> {
  Estilo estilo = Estilo();
  String tipoEscala = "";
  DateTime dataInicial = DateTime.now();
  DateTime dataFinal = DateTime.now();
  List<String> listaDatasFinal = [];
  List<DateTime> listaDatasAuxiliar = [];

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
    //
    dynamic diferencaDias = datasDiferenca
        .difference(dataFinal.add(const Duration(days: 1)))
        .inDays;
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
    listarDatas();
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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
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

    // o ultimo parametro e o tamanho do
    // container do BUTTON NAVIGATION BAR
    double alturaGeral = alturaTela -
        alturaBarraStatus -
        alturaAppBar -
        Constantes.alturaNavigationBar;

    return Theme(
        data: estilo.estiloGeral,
        child: WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: Text(Textos.nomeTelaSelecaoPeriodo),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                width: larguraTela,
                height: alturaGeral,
                child: Stack(
                  children: [
                    FundoTela(altura: alturaGeral),
                    Positioned(
                        child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 10.0, left: 10.0),
                                width: larguraTela,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    alignment: WrapAlignment.spaceAround,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                            bottom: 10.0),
                                        width: larguraTela,
                                        child: Text(
                                          Textos.descricaoTelaSelecaoPeriodo,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Constantes
                                                  .tamanhoLetraDescritivas,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Textos.labelDataInicial,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          textFieldDatas(
                                              larguraTela,
                                              Textos.labelDataInicial,
                                              dataInicial),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Textos.labelDataFinal,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          textFieldDatas(larguraTela,
                                              Textos.labelDataFinal, dataFinal),
                                        ],
                                      )
                                    ],
                                  ),
                                ))),
                        Expanded(
                            flex: 2,
                            child: Container(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 10.0, left: 10.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: Text(
                                          Textos.descricaoListaSelecaoPeriodo,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                              fontSize: Constantes
                                                  .tamanhoLetraDescritivas,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          height: alturaTela * 0.35,
                                          width: larguraTela,
                                          child: ListView(
                                            children: [
                                              ...listaDatasFinal
                                                  .map((e) => Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(Icons
                                                                .date_range),
                                                            const SizedBox(
                                                              width: 10.0,
                                                            ),
                                                            SizedBox(
                                                              width: 300,
                                                              child: Text(
                                                                e,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        Constantes
                                                                            .tamanhoLetraDescritivas,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
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
                                )))
                      ],
                    )),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SizedBox(
              height: Constantes.alturaNavigationBar,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: larguraTela * 0.3,
                          height: 45,
                          child: SingleChildScrollView(
                            child: Text(
                              "Dias da Semana :${widget.listaDias.toString().replaceAll("[", "").replaceAll("]", "")}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Theme(
                        data: estilo.botoesBarraNavegacao,
                        child: SizedBox(
                          width: Constantes.larguraBotoesBarraNavegacao,
                          height: Constantes.alturaBotoesNavegacao,
                          child: ElevatedButton(
                            onPressed: () {
                              if (listaDatasFinal.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(Textos.erroSemIntervalo)));
                              } else {
                                var dados = {};
                                dados[Constantes.parametroGenero] =
                                    widget.genero;
                                dados[Constantes.parametroListaPessoas] =
                                    widget.listaPessoas;
                                dados[Constantes.parametroListaLocal] =
                                    widget.listaLocal;
                                dados[Constantes.parametroListaDias] =
                                    widget.listaDias;
                                dados[Constantes.parametroListaPeriodo] =
                                    listaDatasFinal;
                                Navigator.pushReplacementNamed(
                                    context, Constantes.rotaTelaGerarEscala,
                                    arguments: dados);
                              }
                            },
                            child: const Icon(Icons.arrow_forward, size: Constantes.tamanhoIconeBotoesNavegacao),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        height: 45,
                        width: larguraTela * 0.3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(Textos.txtTipoEscala + tipoEscala,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(height: 60, child: BarraNavegacao()),
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
