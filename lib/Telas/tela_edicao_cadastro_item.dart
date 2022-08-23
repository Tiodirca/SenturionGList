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

class TelaEdicaoCadastroItem extends StatefulWidget {
  const TelaEdicaoCadastroItem(
      {Key? key,
      required this.camposBancoCadastroItem,
      required this.nomeTabela,
      required this.idItem})
      : super(key: key);

  final List<String> camposBancoCadastroItem;
  final String nomeTabela;
  final int idItem;

  @override
  State<TelaEdicaoCadastroItem> createState() => _TelaEdicaoCadastroItemState();
}

class _TelaEdicaoCadastroItemState extends State<TelaEdicaoCadastroItem> {
  Estilo estilo = Estilo();
  List<Map<dynamic, dynamic>> itens = [];
  List<String> chaves = [];
  List<String> valores = [];
  DateTime data = DateTime.now();
  String horarioSemana = "";
  String horarioFinalSemana = "";
  String dataString = "";

//variavel usada para validar o formulario
  final _chaveFormulario = GlobalKey<FormState>();

  // referencia classe para gerenciar o banco de dados
  final bancoDados = BancoDeDados.instance;

  @override
  void initState() {
    super.initState();
    recupararHorarioTroca(); // chamando metodo
    // verificando se o parametro passado para a tela contem os seguintes requisitos
    if (widget.camposBancoCadastroItem.isEmpty) {
      consultarDados();
    } else {
      dataString = converterDataString(data);
      // pegando os valores da lista passados como parametro para a tela
      for (var value1 in widget.camposBancoCadastroItem) {
        chaves.add(value1.toString().replaceAll("_", " "));
        valores.add(""); // add valores vario na lista
      }
      // removendo o primeiro index pois contem o ID
      chaves.removeAt(0);
    }
  }

  // metodo para converter  valor do tipo data para string
  converterDataString(DateTime data) {
    String dataConverida = DateFormat("dd/MM/yyyy EEEE", "pt_BR").format(data);
    return dataConverida;
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
    pegarValoresIndividualBanco();
  }

  pegarValoresIndividualBanco() {
    //pegando valores de forma individual
    for (var value1 in itens.first.keys) {
      chaves.add(value1.toString().replaceAll("_", " "));
    }
    for (var value1 in itens.first.values) {
      valores.add(value1.toString());
    }
    //convertendo string para o tipo data
    data = DateFormat("dd/MM/yyyy EEEE", "pt_BR").parse(valores[1]);
    dataString =
        valores[1] == null ? DateTime.now().toString() : valores[1].toString();
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

  inserir() async {
    // definndo que a lista recebera os seguintes valores
    // nos index determinados
    // index 0 corresponde a data e index 1 corresponde ao horario de troca
    valores[0] = dataString;
    valores[1] = exibirHorarioTroca(dataString);
    Map<String, dynamic> linha = {};
    for (int i = 0; i < chaves.length; i++) {
      linha[chaves.elementAt(i).replaceAll(" ", "_")] = valores.elementAt(i);
    }
    int idDado = await bancoDados.inserir(linha, widget.nomeTabela);
    if (idDado.toString().isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(Textos.sucessoAddBanco)));
    }
  }

  //metodo para recuperar horario gravado no share preferences
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
  }

  // metodo para exibir o horario gravado no share preferences
  // baseado no dia da semana selecionado
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
            if (valor.contains(Constantes.parametroCampoVazio)) {
              valores[index] = "";
            } else {
              valores[index] = valor.toString();
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              return Textos.erroTextFieldVazio;
            }
            return null;
          },
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: label,
            errorStyle: const TextStyle(
                color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
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
        width: 270,
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
            Text(
                tipoExibicao ? Constantes.localData : Constantes.localHoraTroca,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            Text(
                tipoExibicao
                    ? dataString
                    : exibirHorarioTroca(converterDataString(data)),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
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
                title: Text(
                    widget.camposBancoCadastroItem.isEmpty
                        ? Textos.nomeTelaEdicao
                        : Textos.nomeTelaCadastroItem,
                    textAlign: TextAlign.center),
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
                                        widget.camposBancoCadastroItem.isEmpty
                                            ? Textos.descricaoTelaEdicao
                                            : Textos.descricaoTelaCadastroItem,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Constantes
                                                .tamanhoLetraDescritivas,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        Textos.descricaoTelaEdiCadCampoVazio,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                              backgroundColor:
                                                  PaletaCores.corAdtl,
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
                                                  if (widget
                                                      .camposBancoCadastroItem
                                                      .isEmpty) {
                                                    // definindo que a lista vai receber o seguinte valor
                                                    // no seu index passado como parametro
                                                    valores[1] =
                                                        converterDataString(
                                                            data);
                                                    dataString = valores[1];
                                                  } else {
                                                    dataString =
                                                        converterDataString(
                                                            data);
                                                    valores[1] = dataString;
                                                  }
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
                                                    //
                                                    if (index == 0) {
                                                      return Container();
                                                    } else if (index == 1) {
                                                      return Container();
                                                    } else if (index == 2 &&
                                                        widget
                                                            .camposBancoCadastroItem
                                                            .isEmpty) {
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
                    Theme(
                      data: estilo.botoesBarraNavegacao,
                      child: SizedBox(
                        width: Constantes.larguraBotoesBarraNavegacao,
                        height: Constantes.alturaBotoesNavegacao,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_chaveFormulario.currentState!.validate()) {
                              if (widget.camposBancoCadastroItem.isEmpty) {
                                atualizar();
                              } else {
                                inserir();
                              }
                              Navigator.pushReplacementNamed(
                                  context, Constantes.rotaTelaListagem,
                                  arguments: widget.nomeTabela);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(Textos.erroPreenchaCampo)));
                            }
                          },
                          child: Text(
                              widget.camposBancoCadastroItem.isEmpty
                                  ? Textos.btnAtualizar
                                  : Textos.btnCadastrar,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
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
