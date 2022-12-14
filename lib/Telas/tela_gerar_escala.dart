import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:senturionglist/Modelo/pessoa_agrupada.dart';
import 'package:senturionglist/Uteis/Servicos/banco_dados_online.dart';
import 'package:senturionglist/Uteis/Servicos/banco_de_dados_offline.dart';
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
  final bancoDados = BancoDeDadosLocal.instance;
  String tipoEscala = "";
  double alturaNavigationBar = 140.0;
  int valorRadioButton = 0;
  int quantiLocaisDiponivel = 0;
  int quantiLocaisDipoControle = 0;
  bool boolConfigEscala = false;
  bool boolTelaCarregar = false;
  bool boolNomeTabelaExiste = false;
  bool boolErroPessoas = false;

  String querySQL = "";
  final TextEditingController _controllerNomeEscala =
      TextEditingController(text: "");
  List<String> diasSelecionadosAgrupamento = [];
  List<String> locaisSorteio = [];
  List<String> locaisSorteioAgrupamento = [];
  List<int> listaNumeroAuxiliarRepeticao = [];
  List<PessoasAgrupadas> pessoasSelecionadasAgrupamento = [];
  List<CheckBoxModel> itensListaCheckPessoas = [];
  List<CheckBoxModel> itensListaCheckDias = [];

//variavel usada para validar o formulario
  final _chaveFormulario = GlobalKey<FormState>();

  String primeiroHorarioSemana = "TextEditingController(text: " ")";
  String segundoHorarioSemana = "";

  String horarioSemana = "";

  String horarioFinalSemana = "";
  Random random = Random();

  @override
  void initState() {
    super.initState();
    for (var element in widget.listaLocal) {
      locaisSorteio.add(element.toString());
    }
    locaisSorteio.add(Constantes.localUniforme);
    locaisSorteio.add(Constantes.localServirCeia);

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
    locaisSorteio.map(
      (item) {
        querySQL = "$querySQL${item.replaceAll(" ", "_")} TEXT NOT NULL,";
      },
    ).toList();
    // subtraindo o ultimo index da string pois nao e necessario
    querySQL = querySQL.substring(0, querySQL.length - 1);
    chamarRecuperarSharePreferences();
    pegarLocaisSorteioAgrupamento();
  }

  // pegar locais para agrupamento de pessoas
  pegarLocaisSorteioAgrupamento() {
    for (var elemento in locaisSorteio) {
      if (elemento != Constantes.localData &&
          elemento != Constantes.localHoraTroca &&
          elemento != Constantes.localUniforme &&
          elemento != Constantes.localServirCeia) {
        locaisSorteioAgrupamento.add(elemento);
      }
    }
  }

  // metodo para pegar o valor selecionado no check box
  pegarItensPessoasAgrupadas() async {
    for (var elemento in itensListaCheckPessoas) {
      if (elemento.checked == true) {
        sortearLocalAgrupado(elemento);
        pessoasSelecionadasAgrupamento.add(PessoasAgrupadas(
            nome: elemento.texto,
            localTrabalho:
                locaisSorteioAgrupamento.elementAt(elemento.idItem)));
      }
    }
  }

  // metodo para sortear o locais para as pessoas agrupadas
  sortearLocalAgrupado(CheckBoxModel checkBoxModel) {
    int numeroRandomico = random.nextInt(locaisSorteioAgrupamento.length);
    //caso a lista nao contenha o numero randomico entrar no if
    if (!listaNumeroAuxiliarRepeticao.contains(numeroRandomico)) {
      listaNumeroAuxiliarRepeticao.add(numeroRandomico);
      checkBoxModel.idItem = numeroRandomico;
      return checkBoxModel;
    } else {
      sortearLocalAgrupado(checkBoxModel);
    }
  }

  // metodo para pegar os valores do check box
  pegarItensDiasAgrupamento() {
    for (var element in itensListaCheckDias) {
      if (element.checked == true) {
        diasSelecionadosAgrupamento.add(element.texto);
      }
    }
  }

  // metodo para recuperar os valores gravados no share preferences
  chamarRecuperarSharePreferences() async {
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
    String nome = RemoverAcentos.removerAcentos(
        _controllerNomeEscala.text.replaceAll(" ", "_"));
    return nome;
  }

  // metodo para inserir dados na tabela criada
  inserir() async {
    for (int i = 0; i < widget.listaPeriodo.length; i++) {
      Map<String, dynamic> linha = {};
      List<String> valoresInserirBancoOnline = [];
      for (var element in locaisSorteio) {
        // sorteando numero baseado no tamanho da lista
        int numeroRandomico = random.nextInt(widget.listaPessoas.length);
        // sobreescrevendo index do mapa
        linha[Constantes.localData] = widget.listaPeriodo[i];
        // adicionando os valores da lista ao mapa baseado no numero randomico sorteado
        linha[element.replaceAll(" ", "_")] =
            widget.listaPessoas.elementAt(numeroRandomico);
        // Sobre escrevendo o horario de troca baseado nos dias do periodo
        if (widget.listaPeriodo[i].contains(Textos.diaSegunda) ||
            widget.listaPeriodo[i].contains(Textos.diaTerca) ||
            widget.listaPeriodo[i].contains(Textos.diaQuarta) ||
            widget.listaPeriodo[i].contains(Textos.diaQuinta) ||
            widget.listaPeriodo[i].contains(Textos.diaSexta)) {
          linha[Constantes.localHoraTroca.replaceAll(" ", "_")] = horarioSemana;
        } else {
          linha[Constantes.localHoraTroca.replaceAll(" ", "_")] =
              horarioFinalSemana;
        }
        // adicionando valor vazio a determinados campos
        if (element.contains(Constantes.localServirCeia)) {
          linha[Constantes.localServirCeia] = "";
        }
        if (element.contains(Constantes.localUniforme)) {
          linha[Constantes.localUniforme] = "";
        }
      }
      // verificando se a variavel e verdadeira
      if (boolConfigEscala) {
        // pegando o index da lista de dias que devem conter as pessoas agrupadas
        for (int index = 0;
            index < diasSelecionadosAgrupamento.length;
            index++) {
          //print("A${linha["Data"]}");
          if (linha["Data"] == diasSelecionadosAgrupamento.elementAt(index)) {
            for (var element in pessoasSelecionadasAgrupamento) {
              //passando para o mapa um novo valor baseado no tipo de local de trabalho
              // que contem na lista de pessoas agrupadas
              linha[element.localTrabalho.replaceAll(" ", "_")] = element.nome;
            }
          }
        }
      }
      // pegando somente os valores do map e adicionando uma lista
      linha.forEach((key, value) {
        valoresInserirBancoOnline.add(value.toString());
      });

      //chamando metodos de insersao nos banco
      BancoDadosOnline.inserirDadosOnline(
          pegaNomeDigitado(), querySQL, valoresInserirBancoOnline);
      bancoDados.inserir(linha, pegaNomeDigitado());
    }
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, Constantes.rotaTelaSelecaoEscala);
    });
  }

  // metodo para chamar a criacao de tabela no banco de dados online
  criarTabelaBancoOnline() async {
    bool retorno =
        await BancoDadosOnline.criarTabelaOnline(querySQL, pegaNomeDigitado());
    if (retorno) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Textos.sucessoCriarTabelaOnline)));
    } else {
      //print("Erro");
    }
  }

//metodo para mudar o estado do radio button
  void mudarRadioButton(int value) {
    setState(() {
      valorRadioButton = value;
      switch (valorRadioButton) {
        case 0:
          setState(() {
            boolConfigEscala = false;
            quantiLocaisDiponivel = 0;
          });
          break;
        case 1:
          setState(() {
            boolConfigEscala = true;
            quantiLocaisDiponivel = locaisSorteioAgrupamento.length;
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
          boolNomeTabelaExiste = true;
        }
      }
      if (boolNomeTabelaExiste) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Textos.erroGerarEscalaTabelaExistente)));
      } else {
        // verificando se a variavel e verdadeira e se a variave NAO e menor que 0
        if (boolConfigEscala && !(quantiLocaisDiponivel < 0)) {
          pegarItensPessoasAgrupadas();
          pegarItensDiasAgrupamento();
          // verificando se a variavel e verdadeira e se as listas nao estao vazias
          if (boolConfigEscala &&
              (diasSelecionadosAgrupamento.isEmpty ||
                  pessoasSelecionadasAgrupamento.isEmpty)) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(Textos.erroGerarEscalaSemSelecaoAgrupa)));
          } else {
            chamarInserir();
          }
        } else if (!boolConfigEscala) {
          chamarInserir();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(Textos.erroGerarEscalaQuantiPessoas)));
        }
      }
    });
  }

  // metodo para chamar inserir e criar tabela
  chamarInserir() {
    boolTelaCarregar = true;
    chamarCriarTabela();
    criarTabelaBancoOnline();
    Timer(const Duration(seconds: 2), () {
      inserir();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(Textos.sucessoAddBanco)));
    });
  }

// metodo para criar a tabela no banco de dados
  chamarCriarTabela() async {
    await bancoDados.criarTabela(querySQL, pegaNomeDigitado());
  }

  Widget checkBoxPersonalizado(CheckBoxModel checkBoxModel) => CheckboxListTile(
        activeColor: PaletaCores.corAzul,
        checkColor: PaletaCores.corAdtlLetras,
        title: Text(checkBoxModel.texto,
            style: const TextStyle(
                fontSize: Constantes.tamanhoLetraDescritivas,
                fontWeight: FontWeight.bold)),
        value: checkBoxModel.checked,
        side: const BorderSide(width: 2, color: Colors.black),
        onChanged: (value) {
          setState(() {
            checkBoxModel.checked = value!;
            if (value) {
              quantiLocaisDiponivel = quantiLocaisDiponivel - 1;
            } else {
              quantiLocaisDiponivel = quantiLocaisDiponivel + 1;
            }
          });
        },
      );

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
                    if (boolTelaCarregar) {
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
                                                  fontWeight: FontWeight.bold,
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
                                                      'N??o',
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
                                                    visible: boolConfigEscala,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Quantidade de Locais Diponiveis: ${quantiLocaisDiponivel < 0 ? 0 : quantiLocaisDiponivel}",
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Wrap(
                                                          crossAxisAlignment:
                                                              WrapCrossAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  larguraTela *
                                                                      0.5,
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
                                                                          fontSize: Constantes
                                                                              .tamanhoLetraDescritivas,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          alturaTela *
                                                                              0.3,
                                                                      child:
                                                                          ListView(
                                                                        children: [
                                                                          ...itensListaCheckPessoas
                                                                              .map((e) => checkBoxPersonalizado(
                                                                                    e,
                                                                                  ))
                                                                              .toList()
                                                                        ],
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  larguraTela *
                                                                      0.5,
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
                                                                          fontSize: Constantes
                                                                              .tamanhoLetraDescritivas,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          alturaTela *
                                                                              0.3,
                                                                      child:
                                                                          ListView(
                                                                        children: [
                                                                          ...itensListaCheckDias
                                                                              .map((e) => CheckboxWidget(
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
                      );
                    }
                  },
                ),
              ),
              bottomNavigationBar: LayoutBuilder(
                builder: (context, constraints) {
                  if (boolTelaCarregar) {
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
                                  height: Constantes.alturaBotoesNavegacao,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_chaveFormulario.currentState!
                                          .validate()) {
                                        setState(() {
                                          boolNomeTabelaExiste = false;
                                          consultaTabelasExistentes();
                                        });
                                      }
                                    },
                                    child: Text(Textos.btnCriarEscala,
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
