import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/estilo.dart';
import 'package:senturionglist/Uteis/Servicos/recuperar_valor_share_preferences.dart';

import '../Uteis/constantes.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/Servicos/banco_de_dados.dart';
import '../Uteis/textos.dart';
import 'package:intl/intl.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaEdicao extends StatefulWidget {
  const TelaEdicao({Key? key, required this.nomeTabela, required this.idItem})
      : super(key: key);

  final String nomeTabela;
  final int idItem;

  @override
  State<TelaEdicao> createState() => _TelaEdicaoState();
}

class _TelaEdicaoState extends State<TelaEdicao> {
  Estilo estilo = Estilo();
  List<Map<dynamic, dynamic>> itens = [];
  List<String> chaves = [];
  List<String> valores = [];
  bool ativarBotaoHora = false;
  DateTime data = DateTime.now();
  String horarioSemana = "";
  String horarioFinalSemana = "";

//variavel usada para validar o formulario
  final _chaveFormulario = GlobalKey<FormState>();

  // referencia classe para gerenciar o banco de dados
  final bancoDados = BancoDeDados.instance;

  @override
  void initState() {
    super.initState();
    consultarDados();
    recupararHorarioTroca();
  }

  // metodo responsavel por chamar metodo para fazer
  // consulta ao banco de dados
  consultarDados() async {
    await bancoDados
        .consultarPorID(widget.nomeTabela, widget.idItem)
        .then((value) {
      setState(() {
        itens = value;
      });
    });
    pegarValoresIndividual();
  }

  pegarValoresIndividual() {
    //pegando valores de forma individual
    for (var value1 in itens.first.keys) {
      chaves.add(value1.toString().replaceAll("_", " "));
    }
    for (var value1 in itens.first.values) {
      valores.add(value1.toString());
    }
    //convertendo string para o tipo data
    data = DateFormat("dd/MM/yyyy EEEE", "pt_BR").parse(valores[1]);
  }

  atualizar() async {
    Map<String, dynamic> linha = {};
    for (int i = 0; i < chaves.length; i++) {
      linha[chaves.elementAt(i).replaceAll(" ", "_")] = valores.elementAt(i);
    }
    int idDado = await bancoDados.atualizar(linha, widget.nomeTabela);
    if (idDado.toString().isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(Textos.sucessoAtualizarItem)));
    }
  }

  recupararHorarioTroca() async {
    await RecupararValorSharePreferences.recuperarValores(
            Constantes.recuperarValorSemana)
        .then((value) => setState(() {
              horarioSemana = value;
            }));

    await RecupararValorSharePreferences.recuperarValores(
            Constantes.recuperarValorFinalSemana)
        .then((value) => setState(() {
              horarioFinalSemana = value;
            }));

    print(horarioSemana);
    print(horarioFinalSemana);
  }

  exibirHorarioTroca(String data) {
    if (data.contains(Textos.diaSegunda) ||
        data.contains(Textos.diaTerca) ||
        data.contains(Textos.diaQuarta) ||
        data.contains(Textos.diaQuinta) ||
        data.contains(Textos.diaSexta)) {
      return horarioSemana;
    } else {
      return horarioFinalSemana;
    }
  }

  // widget do text field usando na lista para o usuario editar
  Widget textField(String valorInicial, String label, int index) => Container(
        margin: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
        child: TextFormField(
          keyboardType: TextInputType.text,
          initialValue: valorInicial,
          onChanged: (valor) {
            valores[index] = valor.toString();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return Textos.erroTextFieldVazio;
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: label,
            errorStyle: const TextStyle(color: Colors.red, fontSize: 13),
            labelStyle: const TextStyle(
                color: PaletaCores.corAdtl,
                fontSize: 18,
                fontWeight: FontWeight.bold),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.red),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );

  //widget para mostrar informacoes sobre data e horario
  Widget containerInfoForaLista(bool tipoExibicao) => Container(
        margin: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        width: 250,
        height: 45,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tipoExibicao ? chaves[1].toString() : chaves[2].toString(),
                style: const TextStyle(color: Colors.black)),
            Text(
                tipoExibicao
                    ? valores[1].toString()
                    : exibirHorarioTroca(
                        DateFormat("dd/MM/yyyy EEEE", "pt_BR").format(data)),
                style: const TextStyle(color: Colors.black, fontSize: 16)),
          ],
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
            onWillPop: () async {
              Navigator.pushReplacementNamed(
                  context, Constantes.rotaTelaListagem,
                  arguments: widget.nomeTabela);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(Textos.nomeTelaEdicao, textAlign: TextAlign.center),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: larguraTela,
                    height: alturaTela -
                        alturaBarraStatus -
                        alturaAppBar -
                        Constantes.alturaNavigationBar,
                    child: Stack(
                      children: [
                        // o ultimo parametro e o tamanho do container do BUTTON NAVIGATION BAR
                        FundoTela(
                            altura: alturaTela -
                                alturaBarraStatus -
                                alturaAppBar -
                                Constantes.alturaNavigationBar),
                        Positioned(
                            child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  width: larguraTela,
                                  child: Column(
                                    children: [
                                      Text(
                                        Textos.descricaoTelaEdicao,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: Constantes
                                                .tamanhoLetraDescritivas,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    width: larguraTela,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: FloatingActionButton(
                                              onPressed: () async {
                                                DateTime? novaData =
                                                    await showDatePicker(
                                                        builder:
                                                            (context, child) {
                                                          return Theme(
                                                              data: ThemeData
                                                                      .dark()
                                                                  .copyWith(
                                                                colorScheme:
                                                                    const ColorScheme
                                                                        .light(
                                                                  primary:
                                                                      PaletaCores
                                                                          .corAdtl,
                                                                  onPrimary:
                                                                      Colors
                                                                          .white,
                                                                  onSurface:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                                dialogBackgroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              child: child!);
                                                        },
                                                        context: context,
                                                        initialDate: data,
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2100));

                                                if (novaData == null) return;
                                                setState(() {
                                                  data = novaData;
                                                  valores[1] = DateFormat(
                                                          "dd/MM/yyyy EEEE",
                                                          "pt_BR")
                                                      .format(data);
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.date_range,
                                                  size: 30),
                                            ),
                                          ),
                                          Wrap(
                                            alignment:
                                                WrapAlignment.spaceAround,
                                            children: [
                                              containerInfoForaLista(true),
                                              containerInfoForaLista(false)
                                            ],
                                          ),
                                          SizedBox(
                                              width: larguraTela * 0.9,
                                              height: alturaTela * 0.3,
                                              child: Form(
                                                key: _chaveFormulario,
                                                child: ListView.builder(
                                                  itemCount: chaves.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    if (index == 0) {
                                                      return Container();
                                                    } else if (index == 1) {
                                                      return Container();
                                                    } else if (index == 2) {
                                                      return Container();
                                                    } else {
                                                      return textField(
                                                          valores
                                                              .elementAt(index),
                                                          chaves
                                                              .elementAt(index),
                                                          index);
                                                    }
                                                  },
                                                ),
                                              )),
                                        ],
                                      ),
                                    )))
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: SizedBox(
                height: Constantes.alturaNavigationBar,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: Constantes.tamanhoFloatButtonNavigationBar,
                      height: Constantes.tamanhoFloatButtonNavigationBar,
                      child: FloatingActionButton(
                        heroTag: "btnAtualizar",
                        backgroundColor: PaletaCores.corVerdeCiano,
                        onPressed: () async {
                          if (_chaveFormulario.currentState!.validate()) {
                            atualizar();
                            Navigator.pushReplacementNamed(
                                context, Constantes.rotaTelaListagem,
                                arguments: widget.nomeTabela);
                          }
                        },
                        child: Text(Textos.btnAtualizar,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(height: 60, child: BarraNavegacao()),
                  ],
                ),
              ),
            )));
  }
}
