import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:senturionglist/Uteis/Servicos/banco_de_dados.dart';
import 'package:senturionglist/Uteis/Servicos/recuperar_valor_share_preferences.dart';
import 'package:senturionglist/Uteis/remover_acentos.dart';
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
  bool nomeTabelaExiste = false;
  String querySQL = "";
  final TextEditingController _controllerNomeEscala =
      TextEditingController(text: "");
  List<CheckBoxModel> itensListaCheckPessoas = [];
  List<CheckBoxModel> itensListaCheckDias = [];

//variavel usada para validar o formulario
  final _chaveFormulario = GlobalKey<FormState>();

  String primeiroHorarioSemana = "TextEditingController(text: " ")";
  String segundoHorarioSemana = "";

  String horarioSemana = "";

  String horarioFinalSemana = "";

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
    // formando string que contem a query sql
    // utilizada para criar a tabela no banco de dados
    widget.listaLocal.map(
      (item) {
        querySQL = "$querySQL${item.replaceAll(" ", "_")} TEXT NOT NULL,";
      },
    ).toList();
    print(querySQL);
    print(widget.listaLocal);
    // pegando o tamanho da string
    int tamanhoQuery = querySQL.length;
    // subtraindo o ultimo index da string
    querySQL = querySQL.substring(0, tamanhoQuery - 1);
    //recuperarValoresSharePreferences();
    chamarRecuperarValorShare();
  }

  // metodo para recuperar os valores gravados no share preferences
  chamarRecuperarValorShare() async {
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
  }

  // metodo para pegar o valor digitado
  // reescrevendo contendo o caracter passado como parametro
  pegaNomeDigitado() {
    String nome = _controllerNomeEscala.text.replaceAll(" ", "_");
    return nome;
  }

  // metodo para inserir dados na tabela criada
  inserir() async {
    // pegando cada elemento do periodo selecionado
    for (int i = 0; i < widget.listaPeriodo.length; i++) {
      //instanciando variavel
      Random random = Random();
      // criando map temporario
      Map<String, dynamic> linha = {};
      // pegando a lista e fazendo um map adicionando informacoes
      widget.listaLocal.map(
        (item) {
          // passando a data como primeiro elemento
          linha[Constantes.localData] = widget.listaPeriodo[i];
          // verificando se cada data na lista contem os seguintes parametros
          // para setar valor para o segundo elemento do map

          // definindo que a variavel vai receber um index aleatorio da lista
          int numeroRandomico = random.nextInt(widget.listaPessoas.length);
          // adicionando no map um valor contido no index da lista de pessoas
          // a cada item contido na lista de locais
          linha[item.replaceAll(" ", "_")] =
              widget.listaPessoas[numeroRandomico];

          // adicionando valor vazio a determinados campos
          if (item.contains(Constantes.localServirCeia)) {
            linha[Constantes.localServirCeia] = "";
          }
          if (item.contains(Constantes.localUniforme)) {
            linha[Constantes.localUniforme] = "";
          }
          if (widget.listaPeriodo[i].contains(Textos.diaSegunda) ||
              widget.listaPeriodo[i].contains(Textos.diaTerca) ||
              widget.listaPeriodo[i].contains(Textos.diaQuarta) ||
              widget.listaPeriodo[i].contains(Textos.diaQuinta) ||
              widget.listaPeriodo[i].contains(Textos.diaSexta)) {
            linha[Constantes.localHoraTroca.replaceAll(" ", "_")] =
                horarioSemana;
          } else {
            linha[Constantes.localHoraTroca.replaceAll(" ", "_")] =
                horarioFinalSemana;
          }
        },
      ).toList();
      // chamando metodo
      bancoDados.inserir(
          linha, RemoverAcentos.removerAcentos(pegaNomeDigitado()));
      print(linha);
    }
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaSelecaoEscala);
    });
  }

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

  // metodo para consultar se existe alguma tabela com
  // o mesmo nome que o usuario esta criando
  consultaTabelasExistentes() async {
    final tabelasRecuperadas = await bancoDados.consultaTabela();
    setState(() {
      for (var linha in tabelasRecuperadas) {
        var tabela = linha['name'];
        if (pegaNomeDigitado() == tabela) {
          nomeTabelaExiste = true;
        }
      }
      if (nomeTabelaExiste) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Textos.erroGerarEscalaTabelaExistente)));
      } else {
        telaCarregar = true;
        chamarCriarTabela();
        Timer(const Duration(seconds: 3), () {
          inserir();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(Textos.sucessoAddBanco)));
        });
      }
    });
  }

  // metodo para criar a tabela no banco de dados
  chamarCriarTabela() async {
    await bancoDados.criarTabela(
        querySQL, RemoverAcentos.removerAcentos(pegaNomeDigitado()));
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
                                                  fontSize: Constantes
                                                      .tamanhoLetraDescritivas,
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
                                      child: SizedBox(
                                          height: alturaTela * 0.5,
                                          width: larguraTela,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0,
                                                          right: 15.0,
                                                          left: 15.0),
                                                  child: Text(
                                                    Textos
                                                        .descricaoNomesConjuntos,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: Constantes
                                                            .tamanhoLetraDescritivas,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
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
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: configEscala,
                                                  child: Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            larguraTela * 0.5,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 50,
                                                              child: Text(
                                                                Textos
                                                                    .selecaoNomePessoas,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        Constantes
                                                                            .tamanhoLetraDescritivas,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    alturaTela *
                                                                        0.3,
                                                                child: ListView(
                                                                  children: [
                                                                    ...itensListaCheckPessoas
                                                                        .map((e) =>
                                                                            CheckboxWidget(
                                                                              item: e,
                                                                            ))
                                                                        .toList()
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            larguraTela * 0.5,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 50,
                                                              child: Text(
                                                                Textos
                                                                    .selecaoNomeDiasSemana,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        Constantes
                                                                            .tamanhoLetraDescritivas,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    alturaTela *
                                                                        0.3,
                                                                child: ListView(
                                                                  children: [
                                                                    ...itensListaCheckDias
                                                                        .map((e) =>
                                                                            CheckboxWidget(
                                                                              item: e,
                                                                            ))
                                                                        .toList()
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
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
                                width: larguraTela * 0.3,
                                height: 45,
                              ),
                              Theme(
                                data: estilo.botoesBarraNavegacao,
                                child: SizedBox(
                                  width: Constantes.larguraBotoesBarraNavegacao,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_chaveFormulario.currentState!
                                          .validate()) {
                                        setState(() {
                                          nomeTabelaExiste = false;
                                          consultaTabelasExistentes();
                                        });
                                      }
                                    },
                                    child: Text(Textos.btnGerar,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 10.0),
                                height: 45,
                                width: larguraTela * 0.3,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    Textos.txtTipoEscala + tipoEscala,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
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
