import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/Servicos/banco_de_dados.dart';
import 'package:senturionglist/Widget/check_box_widget.dart';
import 'package:senturionglist/Widget/tela_carregamento.dart';
import '../Modelo/check_box_modelo.dart';
import '../Uteis/constantes.dart';
import '../Uteis/estilo.dart';
import '../Uteis/paleta_cores.dart';
import '../Uteis/textos.dart';
import '../Widget/barra_navegacao.dart';
import '../Widget/fundo_tela_widget.dart';

class TelaGerarEscala extends StatefulWidget {
  const TelaGerarEscala(
      {Key? key,
      required this.genero,
      required this.listaLocal,
      required this.listaPessoas,
      required this.listaDias,
      required this.listaPeriodo})
      : super(key: key);

  final bool genero;
  final List<String> listaPessoas;
  final List<String> listaLocal;
  final List<String> listaDias;
  final List<String> listaPeriodo;

  @override
  State<TelaGerarEscala> createState() => _TelaGerarEscalaState();
}

class _TelaGerarEscalaState extends State<TelaGerarEscala> {
  Estilo estilo = Estilo();

  // referencia classe para gerenciar o banco de dados
  final bancoDados = BancoDeDados.instance;
  String tipoEscala = "";
  double alturaNavigationBar = 140.0;
  int valorRadioButton = 0;
  bool configEscala = false;
  bool telaCarregar = false;
  String querySQL = "";
  final TextEditingController _controllerNomeEscala =
      TextEditingController(text: "");
  List<CheckBoxModel> itensListaCheckPessoas = [];
  List<CheckBoxModel> itensListaCheckDias = [];

//variavel usada para validar o formulario
  final _chaveFormulario = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.genero) {
      tipoEscala = Textos.btnCooperadoras;
    } else {
      tipoEscala = Textos.btnCooperador;
    }
    // adicionando informacoes nas listas
    widget.listaPessoas
        .map((e) => itensListaCheckPessoas.add(CheckBoxModel(texto: e)))
        .toList();
    widget.listaPeriodo
        .map((e) => itensListaCheckDias.add(CheckBoxModel(texto: e)))
        .toList();
    // formando string que contem a query sql utilizada para criar a tabela no banco de dados
    widget.listaLocal.map(
      (item) {
        querySQL = "$querySQL${item.replaceAll(" ", "")} TEXT NOT NULL,";
      },
    ).toList();

    int tamanhoQuery = querySQL.length;
    querySQL = querySQL.substring(0, tamanhoQuery - 1);
    print(querySQL);
    String tabela = "teste";
    //bancoDados.criarTabela(querySQL, tabela);

    // teste();
    // Timer(const Duration(seconds: 10), () {
    //   consulta();
    // });
    //inserir();
  }

  inserir() async {
    for (int i = 0; i < widget.listaPeriodo.length; i++) {
      Random random = Random();
      Map<String, dynamic> linha = {};
      widget.listaLocal.map(
        (e) {
         linha[Textos.localData] = widget.listaPeriodo[i];
          if (widget.listaPeriodo[i].contains(Textos.diaQuarta) ||
              widget.listaPeriodo[i].contains(Textos.diaSexta)) {
            linha[Textos.localHoraTroca.replaceAll(" ", "")] = "19:00 ás 20:00";
          } else {
            linha[Textos.localHoraTroca.replaceAll(" ", "")] = "18:00 às 19:00";
          }
          int randomNumber = random.nextInt(widget.listaPessoas.length);
          linha[e.replaceAll(" ", "")] = widget.listaPessoas[randomNumber];
        },
      ).toList();
      bancoDados.inserir(linha, _controllerNomeEscala.text);
      print(linha);
    }
  }

  // teste() async {
  //   Map<String, dynamic> linha = {
  //     'altura': "_controllerNomePessoa.text",
  //     'largura': "valorGenero"
  //   };
  //   await bancoDados.inserir(linha, "teste");
  // }
  //
  // consulta() async {
  //   final registros = await bancoDados.consultarLinhas("teste");
  //   for (var linha in registros) {
  //     print(linha);
  //   }
  // }

  //metodo para mudar o estado do radio button
  void mudarRadioButton(int value) {
    setState(() {
      valorRadioButton = value;
      switch (valorRadioButton) {
        case 0:
          setState(() {
            configEscala = false;
          });
          break;
        case 1:
          setState(() {
            configEscala = true;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;
    double alturaGeral = alturaTela -
        alturaBarraStatus -
        alturaAppBar -
        Constantes.alturaNavigationBar;

    return Theme(
        data: estilo.estiloGeral,
        child: WillPopScope(
          child: Scaffold(
              appBar: AppBar(
                title: Text(Textos.nomeTelaGerarEscala,
                    textAlign: TextAlign.center),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (telaCarregar) {
                      return Container(
                          color: PaletaCores.corAdtl,
                          width: larguraTela,
                          height: alturaGeral,
                          child: const Center(
                            child: TelaCarregamento(),
                          ));
                    } else {
                      return SingleChildScrollView(
                        child: SizedBox(
                          width: larguraTela,
                          height: alturaGeral,
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
                                        padding: const EdgeInsets.only(
                                            top: 10.0, right: 10.0, left: 10.0),
                                        width: larguraTela,
                                        child: Column(
                                          children: [
                                            Text(
                                              Textos.decricaoTelaGerarEscala,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0,
                                                    top: 10.0,
                                                    right: 5.0,
                                                    bottom: 5.0),
                                                width: larguraTela * 0.5,
                                                child: Form(
                                                  key: _chaveFormulario,
                                                  child: TextFormField(
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return Textos
                                                            .erroTextFieldVazio;
                                                      }
                                                      return null;
                                                    },
                                                    controller:
                                                        _controllerNomeEscala,
                                                    decoration: InputDecoration(
                                                      labelText: Textos
                                                          .labelNomeEscala,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 0.0,
                                              right: 10.0,
                                              left: 10.0),
                                          height: alturaTela * 0.4,
                                          width: larguraTela,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text(
                                                  Textos
                                                      .descricaoNomesConjuntos,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Radio(
                                                        value: 0,
                                                        activeColor:
                                                            PaletaCores.corAzul,
                                                        groupValue:
                                                            valorRadioButton,
                                                        onChanged: (_) {
                                                          mudarRadioButton(0);
                                                        }),
                                                    const Text(
                                                      'Não',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    Radio(
                                                        value: 1,
                                                        activeColor:
                                                            PaletaCores.corAdtl,
                                                        groupValue:
                                                            valorRadioButton,
                                                        onChanged: (_) {
                                                          mudarRadioButton(1);
                                                        }),
                                                    const Text(
                                                      'Sim',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: configEscala,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: larguraTela *
                                                                0.4,
                                                            height: 50,
                                                            child: Text(
                                                              Textos
                                                                  .selecaoNomePessoas,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  alturaTela *
                                                                      0.3,
                                                              width:
                                                                  larguraTela *
                                                                      0.4,
                                                              child: ListView(
                                                                children: [
                                                                  ...itensListaCheckPessoas
                                                                      .map((e) =>
                                                                          CheckboxWidget(
                                                                            item:
                                                                                e,
                                                                          ))
                                                                      .toList()
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: larguraTela *
                                                                0.4,
                                                            height: 50,
                                                            child: Text(
                                                              Textos
                                                                  .selecaoNomeDiasSemana,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  alturaTela *
                                                                      0.3,
                                                              width:
                                                                  larguraTela *
                                                                      0.4,
                                                              child: ListView(
                                                                children: [
                                                                  ...itensListaCheckDias
                                                                      .map((e) =>
                                                                          CheckboxWidget(
                                                                            item:
                                                                                e,
                                                                          ))
                                                                      .toList()
                                                                ],
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )))
                                ],
                              )),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              bottomNavigationBar: LayoutBuilder(
                builder: (context, constraints) {
                  if (telaCarregar) {
                    return Container(
                      width: larguraTela,
                      height: Constantes.alturaNavigationBar,
                      color: PaletaCores.corAdtl,
                    );
                  } else {
                    return SizedBox(
                      height: Constantes.alturaNavigationBar,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: larguraTela * 0.4,
                                height: 45,
                              ),
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: FloatingActionButton(
                                  backgroundColor: PaletaCores.corVerdeCiano,
                                  onPressed: () {
                                    if (_chaveFormulario.currentState!
                                        .validate()) {
                                      setState(() {
                                        telaCarregar = true;
                                        bancoDados.criarTabela(
                                            querySQL,
                                            _controllerNomeEscala.text);
                                        Timer(const Duration(seconds: 2), () {
                                          inserir();
                                        });
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  Textos.sucessoAddBanco)));
                                    }
                                  },
                                  child: const Text("Gerar",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
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
                          const SizedBox(height: 60, child: BarraNavegacao()),
                        ],
                      ),
                    );
                  }
                },
              )),
          onWillPop: () async {
            var dados = {};
            dados[Constantes.parametroGenero] = widget.genero;
            dados[Constantes.parametroListaPessoas] = widget.listaPessoas;
            dados[Constantes.parametroListaLocal] = widget.listaLocal;
            dados[Constantes.parametroListaDias] = widget.listaDias;
            Navigator.pushReplacementNamed(
                context, Constantes.rotaTelaSelecaoPeriodo,
                arguments: dados);
            return false;
          },
        ));
  }
}
